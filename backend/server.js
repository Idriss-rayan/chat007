// ---------------------------
// Import des modules
// ---------------------------
require('dotenv').config(); // 👈 charge les variables depuis .env
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// ---------------------------
// Configuration du serveur
// ---------------------------
const app = express();
app.use(bodyParser.json());

const PORT = 3000;
const SECRET_KEY = process.env.JWT_SECRET;

// ---------------------------
// Connexion à MySQL
// ---------------------------
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) {
        console.error('❌ Erreur de connexion MySQL:', err);
        process.exit(1);
    }
    console.log('✅ Connecté à la base MySQL:', process.env.DB_NAME);
});

// ---------------------------
// Route d'inscription
// ---------------------------
app.post('/register', async (req, res) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({ message: 'Tous les champs sont requis' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);

        db.query(
            'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
            [username, email, hashedPassword],
            (err, results) => {
                if (err) {
                    console.error('Erreur MySQL:', err);
                    return res.status(500).json({ message: 'Erreur lors de la création de l’utilisateur' });
                }

                // ✅ Génération du token JWT
                const token = jwt.sign(
                    { id: results.insertId, email: email },
                    SECRET_KEY, // ⚠️ mets une vraie clé secrète dans une variable d'environnement
                    { expiresIn: '2h' }
                );

                // ✅ Réponse complète
                res.status(201).json({
                    message: 'Utilisateur créé avec succès',
                    user: { id: results.insertId, username, email },
                    token: token
                });
            }
        );
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur', error: err });
    }
});

// ---------------------------
// Route de connexion
// ---------------------------
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: 'Email et mot de passe requis' });
    }

    db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
        if (err) return res.status(500).json({ message: 'Erreur serveur', error: err });

        if (results.length === 0) {
            return res.status(401).json({ message: 'Utilisateur non trouvé' });
        }

        const user = results[0];
        const match = await bcrypt.compare(password, user.password);

        if (!match) {
            return res.status(401).json({ message: 'Mot de passe incorrect' });
        }

        const token = jwt.sign(
            { id: user.id, username: user.username },
            SECRET_KEY,
            //{ expiresIn: '8h' }
        );

        res.json({ message: 'Connexion réussie', token });
    });
});

// ---------------------------
// Route pour ajouter des infos utilisateur
// ---------------------------
app.post('/user-info', authenticateToken, (req, res) => {
    const { first_name, last_name, email, country, city, gender } = req.body;
    const user_id = req.user.id;

    if (!first_name || !last_name || !email) {
        return res.status(400).json({ message: 'first_name, last_name et email sont requis' });
    }

    let genderValue = gender || 'Autre';
    if (genderValue.toLowerCase() === 'female') genderValue = 'Femme';
    if (genderValue.toLowerCase() === 'male') genderValue = 'Homme';

    const sql = `
      INSERT INTO user_infos (user_id, first_name, last_name, email, country, city, gender)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        first_name = VALUES(first_name),
        last_name = VALUES(last_name),
        email = VALUES(email),
        country = VALUES(country),
        city = VALUES(city),
        gender = VALUES(gender)
    `;

    db.query(sql, [user_id, first_name, last_name, email, country || null, city || null, genderValue], (err, results) => {
        if (err) {
            console.error('Erreur MySQL:', err);
            return res.status(500).json({ message: 'Erreur lors de l’insertion des infos', error: err });
        }
        res.status(201).json({ message: 'Infos utilisateur enregistrées avec succès' });
    });
});
//------------------------------------------------
// Récupérer les infos de l'utilisateur connecté
//________________________________________________

app.get('/user-info', authenticateToken, (req, res) => {
    const user_id = req.user.id;

    const sql = 'SELECT * FROM user_infos WHERE user_id = ?';
    db.query(sql, [user_id], (err, results) => {
        if (err) {
            console.error('Erreur MySQL:', err);
            return res.status(500).json({ message: 'Erreur serveur', error: err });
        }

        if (results.length === 0) {
            return res.json({ hasInfo: false });
        }

        res.json({ hasInfo: true, data: results[0] });
    });
});

//------------------------------------------------
// Obtenir la listes des utilisateurs from mysql |
//------------------------------------------------

app.get('/users', (req, res) => {
    const sql = `SELECT id, first_name,CONCAT(first_name, ' ', last_name) AS name, gender, country FROM user_infos`;
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Erreur lors de la récupération des utilisateurs:', err);
            return res.status(500).json({ message: 'Erreur serveur' });
        }
        res.json(results);
    });
});

// ===========================
// 🔹 FOLLOW un utilisateur
// ===========================
app.post('/follow', (req, res) => {
    const { followerId, followedId } = req.body; // ← snake_case

    if (followerId === followedId) {
        return res.status(400).json({ message: "Tu ne peux pas te suivre toi-même" });
    }

    const sql = `INSERT IGNORE INTO followers (follower_id, followed_id) VALUES (?, ?)`;
    db.query(sql, [followerId, followedId], (err, result) => {
        if (err) {
            console.error('Erreur follow:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }
        res.json({ message: 'Utilisateur suivi avec succès' });
    });
});


// ===========================
// 🔹 UNFOLLOW un utilisateur
// ===========================
app.post('/unfollow', (req, res) => {
    const { followerId, followedId } = req.body;

    const sql = `
    DELETE FROM followers
    WHERE follower_id = ? AND followed_id = ?
  `;
    db.query(sql, [followerId, followedId], (err, result) => {
        if (err) {
            console.error('Erreur unfollow:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }
        res.json({ message: 'Unfollow réussi' });
    });
});

// ===========================
// 🔹 Récupérer MES FOLLOWERS
// (ceux qui me suivent)
// ===========================
app.get('/followers/:userId', (req, res) => {
    const userId = req.params.userId;

    const sql = `
    select concat (ui.first_name ,' ', ui.last_name) as name, ui.country, u.id,
    ui.email from followers f 
    join users u on f.follower_id = u.id 
    join user_infos ui on u.id = ui.user_id where f.followed_id = ?
  `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Erreur récupération followers:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }
        res.json(results);
    });
});

// ===========================
// 🔹 Récupérer LES PERSONNES 
//    QUE JE SUIS
// ===========================
app.get('/following/:userId', (req, res) => {
    const userId = req.params.userId;

    const sql = `
    select concat (ui.first_name ,' ', ui.last_name) as name, ui.country, ui.city,
    ui.email from followers f 
    join users u on f.followed_id = u.id 
    join user_infos ui on u.id = ui.user_id where f.follower_id = ?
  `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Erreur récupération following:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }
        res.json(results);
    });
});

// ===========================
// 🔹 Vérifier si je follow déjà un utilisateur
// (utile pour afficher le bouton "Follow"/"Unfollow")
// ===========================
app.get('/is-following', (req, res) => {
    const { followerId, followedId } = req.query;

    const sql = `
    SELECT * FROM followers
    WHERE follower_id = ? AND followed_id = ?
  `;
    db.query(sql, [followerId, followedId], (err, results) => {
        if (err) {
            console.error('Erreur vérification follow:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }
        res.json({ isFollowing: results.length > 0 });
    });
});


// ---------------------------
// Middleware d’authentification JWT
// ---------------------------
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.sendStatus(401);

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}


// =========================================
// 🔹 Récupérer les statistiques utilisateur
// =========================================
app.get('/user-stats/:userId', (req, res) => {
    const userId = req.params.userId;

    // Compter les followers
    const followersQuery = 'SELECT COUNT(*) as count FROM followers WHERE followed_id = ?';

    // Compter les following
    const followingQuery = 'SELECT COUNT(*) as count FROM followers WHERE follower_id = ?';

    // Exécuter les requêtes en parallèle
    db.query(followersQuery, [userId], (err, followersResult) => {
        if (err) {
            console.error('Erreur comptage followers:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }

        db.query(followingQuery, [userId], (err, followingResult) => {
            if (err) {
                console.error('Erreur comptage following:', err);
                return res.status(500).json({ error: 'Erreur serveur' });
            }

            // Retourner les résultats sans les groupes pour l'instant
            res.json({
                totalContacts: followersResult[0].count,
                groupsCount: 0, // Mettre à 0 puisque vous n'avez pas de groupes
                followingCount: followingResult[0].count,
                lastSeen: "En ligne"
            });
        });
    });
});

// ===========================
// 🔹 Récupérer les informations utilisateur complètes
// ===========================
app.get('/profile/:userId', authenticateToken, (req, res) => {
    const userId = req.params.userId;

    const sql = `
        SELECT 
            u.id,
            u.username,
            u.email,
            u.is_online,
            u.created_at,
            ui.first_name,
            ui.last_name,
            ui.country,
            ui.city,
            ui.gender,
            ui.bio,
            ui.avatar_url
        FROM users u
        LEFT JOIN user_infos ui ON u.id = ui.user_id
        WHERE u.id = ?
    `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Erreur récupération profil:', err);
            return res.status(500).json({ error: 'Erreur serveur' });
        }

        if (results.length === 0) {
            return res.status(404).json({ message: 'Utilisateur non trouvé' });
        }

        const user = results[0];
        res.json({
            id: user.id,
            userName: user.username,
            firstName: user.first_name,
            lastName: user.last_name,
            email: user.email,
            country: user.country,
            city: user.city,
            gender: user.gender,
            bio: user.bio,
            avatarUrl: user.avatar_url,
            isOnline: user.is_online,
            joinDate: user.created_at,
            phoneNumber: user.phone_number // Si disponible
        });
    });
});
//========================
// 1. Ajouter un contact
//========================
app.post('/contacts', (req, res) => {
    const { user_id, contact_id } = req.body;

    console.log('🔄 Tentative d\'ajout de contact:', { user_id, contact_id });

    // Vérifier que les données sont présentes
    if (!user_id || !contact_id) {
        return res.status(400).json({
            error: 'Données manquantes: user_id et contact_id sont requis'
        });
    }

    // Vérifier si le contact existe déjà
    const checkSql = 'SELECT id FROM contacts WHERE user_id = ? AND contact_id = ?';

    db.query(checkSql, [user_id, contact_id], (err, results) => {
        if (err) {
            console.error('❌ Erreur SQL (check):', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        if (results.length > 0) {
            console.log('⚠️ Contact déjà existant');
            return res.status(400).json({ error: 'Contact déjà existant' });
        }

        // Ajouter le contact
        const insertSql = 'INSERT INTO contacts (user_id, contact_id) VALUES (?, ?)';

        db.query(insertSql, [user_id, contact_id], (err, results) => {
            if (err) {
                console.error('❌ Erreur SQL (insert):', err);
                return res.status(500).json({ error: 'Erreur lors de l\'ajout du contact' });
            }

            console.log('✅ Contact ajouté avec succès, ID:', results.insertId);
            res.status(201).json({
                success: true,
                message: 'Contact ajouté avec succès',
                contactId: results.insertId
            });
        });
    });
});

//=========================
// 2. Supprimer un contact
//=========================
app.delete('/contacts', (req, res) => {
    const { user_id, contact_id } = req.body;

    console.log('🔄 Tentative de suppression de contact:', { user_id, contact_id });

    if (!user_id || !contact_id) {
        return res.status(400).json({
            error: 'Données manquantes: user_id et contact_id sont requis'
        });
    }

    const sql = 'DELETE FROM contacts WHERE user_id = ? AND contact_id = ?';

    db.query(sql, [user_id, contact_id], (err, results) => {
        if (err) {
            console.error('❌ Erreur SQL (delete):', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        if (results.affectedRows === 0) {
            console.log('⚠️ Contact non trouvé pour suppression');
            return res.status(404).json({ error: 'Contact non trouvé' });
        }

        console.log('✅ Contact supprimé avec succès');
        res.json({
            success: true,
            message: 'Contact supprimé avec succès'
        });
    });
});

//---------------------------------
// 3. Vérifier si un contact existe
//---------------------------------
app.get('/contacts/check', (req, res) => {
    const user_id = req.query.user_id;
    const contact_id = req.query.contact_id;

    console.log('🔄 Vérification contact:', { user_id, contact_id });

    if (!user_id || !contact_id) {
        return res.status(400).json({
            error: 'Paramètres manquants: user_id et contact_id sont requis'
        });
    }

    const sql = 'SELECT id FROM contacts WHERE user_id = ? AND contact_id = ?';

    db.query(sql, [user_id, contact_id], (err, results) => {
        if (err) {
            console.error('❌ Erreur SQL (check):', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        const exists = results.length > 0;
        console.log('✅ Vérification terminée, existe:', exists);

        res.json({
            exists: exists,
            success: true
        });
    });
});
//----------------------------------------------
// 4. Obtenir tous les contacts d'un utilisateur
//----------------------------------------------
app.get('/contacts/:user_id', (req, res) => {
    const userId = req.params.user_id;

    console.log('🔄 Récupération des contacts pour user_id:', userId);

    if (!userId) {
        return res.status(400).json({ error: 'user_id est requis' });
    }

    // Cette requête suppose que tu as une table 'users' avec ces colonnes
    const sql = `
    SELECT 
    ui.user_id AS contact_id,
    ui.first_name,
    ui.last_name,
    ui.email,
    ui.country,
    ui.city,
    ui.gender,
    c.created_at AS added_on
   FROM contacts c
   JOIN user_infos ui 
   ON c.contact_id = ui.user_id
   WHERE c.user_id = 1
   ORDER BY ui.first_name ASC
  `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('❌ Erreur SQL (get contacts):', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        console.log('✅ Contacts récupérés:', results.length);
        res.json({
            success: true,
            contacts: results
        });
    });
});


// ---------------------------
// Exemple de route protégée
// ---------------------------
app.get('/dashboard', authenticateToken, (req, res) => {
    res.json({ message: `Bienvenue ${req.user.username} 👋` });
});

// ---------------------------
// Démarrage du serveur
// ---------------------------
app.listen(PORT, () => {
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});
