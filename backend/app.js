// app.js
const express = require("express");
const mysql = require("mysql2/promise");
const bodyParser = require("body-parser");

const app = express();
const PORT = 3000;

app.use(bodyParser.json()); // pour traiter le JSON

// ----------- Connexion MySQL -----------
let db;

async function initDB() {
    try {
        db = await mysql.createConnection({
            host: "127.0.0.1",
            user: "root",           // ou "api_user"
            password: "rayan2003",  // ton mot de passe
            database: "flutter_db",
            port: 3306
        });
        console.log("✅ Connecté à MySQL !");
    } catch (err) {
        console.error("❌ Erreur de connexion MySQL :", err.message);
        process.exit(1); // quitte si erreur
    }
}

// ----------- Routes API -----------

// GET all users
app.get("/users", async (req, res) => {
    try {
        const [rows] = await db.query("SELECT * FROM users");
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET user by id
app.get("/users/:id", async (req, res) => {
    try {
        const [rows] = await db.query("SELECT * FROM users WHERE id = ?", [req.params.id]);
        if (rows.length === 0) return res.status(404).json({ error: "User not found" });
        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// POST create new user
app.post("/users", async (req, res) => {
    const { name, email, age } = req.body;
    try {
        const [result] = await db.query(
            "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
            [name, email, age]
        );
        res.status(201).json({ id: result.insertId, name, email, age });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// PUT update user by id
app.put("/users/:id", async (req, res) => {
    const { name, email, age } = req.body;
    try {
        const [result] = await db.query(
            "UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?",
            [name, email, age, req.params.id]
        );
        if (result.affectedRows === 0) return res.status(404).json({ error: "User not found" });
        res.json({ id: req.params.id, name, email, age });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// DELETE user by id
app.delete("/users/:id", async (req, res) => {
    try {
        const [result] = await db.query("DELETE FROM users WHERE id = ?", [req.params.id]);
        if (result.affectedRows === 0) return res.status(404).json({ error: "User not found" });
        res.json({ message: "User deleted" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ----------- Lancement serveur -----------
app.listen(PORT, async () => {
    await initDB();
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});
