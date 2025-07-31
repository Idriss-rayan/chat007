const express = require("express");
const router = express.Router();
const User = require("../models/User");

// Obtenir tous les utilisateurs sauf celui connecté
router.get("/", async (req, res) => {
  try {
    const { email } = req.query;

    // Vérifie que l'email est fourni
    if (!email) {
      return res.status(400).json({ message: "Email requis dans la requête" });
    }

    // Récupère tous les utilisateurs sauf celui connecté
    const users = await User.find({ email: { $ne: email } }).select("-password");
    res.status(200).json(users);
  } catch (err) {
    console.error("Erreur lors de la récupération des utilisateurs :", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
});

module.exports = router;
