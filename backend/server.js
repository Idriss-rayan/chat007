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
            { expiresIn: '8h' }
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
    select concat (ui.first_name ,' ', ui.last_name) as name, ui.country,
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
// 🔹 Récupérer LES PERSONNES QUE JE SUIS
// ===========================
app.get('/following/:userId', (req, res) => {
    const userId = req.params.userId;

    const sql = `
    SELECT u.id, u.username, ui.profile_picture
    FROM followers f
    JOIN users u ON f.followed_id = u.id
    LEFT JOIN user_infos ui ON u.id = ui.user_id
    WHERE f.follower_id = ?
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
