const express = require("express");
const router = express.Router();
const { register, login } = require("../controllers/authController");
const User = require("../models/User");

router.post("/register", register);
router.post("/login", login);

router.get("/users", async (req, res) => {
  try {
    const { email } = req.query;

    let users;
    if (email) {
      // Si un email est passé, on l’exclut
      users = await User.find({ email: { $ne: email } }).select("-password");
    } else {
      // Sinon, on retourne tous les utilisateurs (moins sécurisé)
      users = await User.find().select("-password");
    }

    res.json(users);
  } catch (err) {
    console.error("Erreur /users :", err.message);
    res.status(500).json({ message: "Erreur serveur" });
  }
});

module.exports = router;
