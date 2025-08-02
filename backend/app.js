const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes");
const Message = require("./models/message");

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

// Routes d'authentification et utilisateurs
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);

// Route pour récupérer les messages entre deux utilisateurs
app.get("/api/messages", async (req, res) => {
  const { sender, receiver } = req.query;

  // Validation des paramètres
  if (!sender || !receiver) {
    return res.status(400).json({ message: "Paramètres sender et receiver requis" });
  }

  try {
    const messages = await Message.find({
      $or: [
        { sender, receiver },
        { sender: receiver, receiver: sender },
      ]
    }).sort({ timestamp: 1 });

    res.json(messages);
  } catch (err) {
    console.error("❌ Erreur dans /api/messages :", err.message);
    res.status(500).json({ message: "Erreur serveur" });
  }
});

// Connexion à MongoDB et lancement du serveur
const PORT = process.env.PORT || 5000;

mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("✅ MongoDB connecté");
    app.listen(PORT, () => {
      console.log("🚀 Serveur lancé sur le port", PORT);
    });
  })
  .catch((err) => {
    console.error("❌ Erreur MongoDB :", err.message);
  });
