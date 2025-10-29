// ---------------------------
// Import des modules
// ---------------------------
require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const http = require('http');
const { Server } = require('socket.io');

// ---------------------------
// Configuration du serveur
// ---------------------------
const app = express();
app.use(bodyParser.json());
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: '*' }
});

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

//===================================================================
const users = {}; // Mapping: userId -> socket.id
const userSockets = new Map();

// Middleware d'authentification Socket.io
io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    console.log('🔐 Token reçu:', token?.substring(0, 20) + '...'); // 🔥 Log partiel

    if (!token) {
        return next(new Error('Authentication error'));
    }

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return next(new Error('Authentication error'));

        socket.userId = user.id;
        next();
    });
});

// Quand un client se connecte
io.on('connection', (socket) => {
    console.log('🟢 Nouveau client connecté:', socket.id, 'User ID:', socket.userId);

    // Auto-register avec le userId du JWT
    if (socket.userId) {
        // Nettoyer l'ancien mapping pour cet userId
        for (const [existingUserId, existingSocketId] of Object.entries(users)) {
            if (existingUserId === socket.userId.toString()) {
                delete users[existingUserId];
                break;
            }
        }

        users[socket.userId] = socket.id;
        console.log(`📱 User ${socket.userId} enregistré avec socket ${socket.id}`);
    }

    // 🔹 Envoi d'un message privé
    socket.on('private_message', ({ to, message }) => {
        const targetSocketId = users[to];
        if (targetSocketId) {
            io.to(targetSocketId).emit('private_message', {
                from: socket.userId,
                message,
            });
            console.log(`📩 Message privé de ${socket.userId} vers ${to}: ${message}`);
        } else {
            console.log(`⚠️ Utilisateur ${to} introuvable ou déconnecté`);
        }
    });

    // 🔹 Déconnexion
    socket.on('disconnect', () => {
        if (socket.userId) {
            delete users[socket.userId];
            console.log(`🔴 Utilisateur ${socket.userId} déconnecté`);
        }
    });
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
                    return res.status(500).json({ message: "Erreur lors de la création de l'utilisateur" });
                }

                // ✅ Génération du token JWT
                const token = jwt.sign(
                    { id: results.insertId, email: email },
                    SECRET_KEY,

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

        console.log('🔐 User trouvé:', {
            id: user.id,
            email: user.email,
            username: user.username
        });

        // 🔥 GÉNÈRE LE TOKEN AVEC LE BON USER
        const tokenPayload = {
            id: user.id,
            username: user.username
        };

        const token = jwt.sign(tokenPayload, SECRET_KEY);

        // 🔥 VÉRIFIE CE QUE CONTIENT LE TOKEN
        const decoded = jwt.verify(token, SECRET_KEY);
        console.log('🔐 Token généré pour user ID:', decoded.id);

        res.json({
            message: 'Connexion réussie',
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email
            }
        });
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
            return res.status(500).json({ message: "Erreur lors de l'insertion des infos", error: err });
        }
        res.status(201).json({ message: 'Infos utilisateur enregistrées avec succès' });
    });
});

//------------------------------------------------
// Récupérer les infos de l'utilisateur connecté
//------------------------------------------------
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
    const { followerId, followedId } = req.body;

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

// =========================================
// 🔹 Récupérer les statistiques utilisateur
// =========================================
app.get('/user-stats/:userId', (req, res) => {
    const userId = req.params.userId;

    const followersQuery = 'SELECT COUNT(*) as count FROM followers WHERE followed_id = ?';
    const followingQuery = 'SELECT COUNT(*) as count FROM followers WHERE follower_id = ?';

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

            res.json({
                totalContacts: followersResult[0].count,
                groupsCount: 0,
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
            phoneNumber: user.phone_number
        });
    });
});

//========================
// 1. Ajouter un contact
//========================
app.post('/contacts', (req, res) => {
    const { user_id, contact_id } = req.body;

    console.log('🔄 Tentative d\'ajout de contact:', { user_id, contact_id });

    if (!user_id || !contact_id) {
        return res.status(400).json({
            error: 'Données manquantes: user_id et contact_id sont requis'
        });
    }

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

    const sql = `
  SELECT 
    c.*,
    ui.user_id AS contact_user_id,
    ui.first_name,   
    ui.last_name,
    ui.email,   
    ui.country,   
    ui.city,
    ui.gender,
    c.created_at AS added_on
  FROM contacts c 
  JOIN user_infos ui ON c.contact_id = ui.user_id 
  WHERE c.user_id = ? 
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

// ===========================
// 🔹 Vérifier/Créer une room privée
// ===========================
app.post('/private-room', authenticateToken, (req, res) => {
    const { contactUserId } = req.body;
    const currentUserId = req.user.id;

    console.log('🔄 Création room privée:', { currentUserId, contactUserId });

    if (!contactUserId) {
        return res.status(400).json({ error: 'contactUserId est requis' });
    }

    const checkRoomSql = `
        SELECT r.* 
        FROM rooms r
        JOIN room_members rm1 ON r.id = rm1.room_id AND rm1.user_id = ?
        JOIN room_members rm2 ON r.id = rm2.room_id AND rm2.user_id = ?
        WHERE r.type = 'private'
    `;

    db.query(checkRoomSql, [currentUserId, contactUserId], (err, results) => {
        if (err) {
            console.error('❌ Erreur vérification room:', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        if (results.length > 0) {
            console.log('✅ Room existante trouvée:', results[0].id);
            return res.json({
                success: true,
                room: results[0],
                isNew: false
            });
        }

        const createRoomSql = 'INSERT INTO rooms (type, created_by) VALUES (?, ?)';

        db.query(createRoomSql, ['private', currentUserId], (err, roomResults) => {
            if (err) {
                console.error('❌ Erreur création room:', err);
                return res.status(500).json({ error: 'Erreur création room' });
            }

            const newRoomId = roomResults.insertId;
            console.log('✅ Nouvelle room créée:', newRoomId);

            const addMembersSql = 'INSERT INTO room_members (room_id, user_id) VALUES (?, ?), (?, ?)';

            db.query(addMembersSql, [newRoomId, currentUserId, newRoomId, contactUserId], (err, memberResults) => {
                if (err) {
                    console.error('❌ Erreur ajout membres:', err);
                    return res.status(500).json({ error: 'Erreur ajout membres' });
                }

                console.log('✅ Membres ajoutés à la room');

                const getRoomSql = 'SELECT * FROM rooms WHERE id = ?';
                db.query(getRoomSql, [newRoomId], (err, roomInfo) => {
                    if (err) {
                        console.error('❌ Erreur récupération room:', err);
                        return res.status(500).json({ error: 'Erreur récupération room' });
                    }

                    res.json({
                        success: true,
                        room: roomInfo[0],
                        isNew: true
                    });
                });
            });
        });
    });
});

// ===========================
// 🔹 Récupérer les rooms d'un utilisateur
// ===========================
app.get('/user-rooms', authenticateToken, (req, res) => {
    const currentUserId = req.user.id;

    const sql = `
        SELECT r.*, rm.joined_at
        FROM rooms r
        JOIN room_members rm ON r.id = rm.room_id
        WHERE rm.user_id = ?
        ORDER BY rm.joined_at DESC
    `;

    db.query(sql, [currentUserId], (err, results) => {
        if (err) {
            console.error('❌ Erreur récupération rooms:', err);
            return res.status(500).json({ error: 'Erreur base de données' });
        }

        res.json({
            success: true,
            rooms: results
        });
    });
});

// ---------------------------
// Middleware d'authentification JWT
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
server.listen(PORT, () => {
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});