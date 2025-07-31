const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes"); // 🔄 bien après express()

dotenv.config();

const app = express(); // ✅ Initialisation AVANT app.use

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes); // 🔄 correct ici

// Connexion MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("✅ MongoDB connecté");
    app.listen(process.env.PORT, () => {
      console.log("🚀 Serveur lancé sur le port", process.env.PORT);
    });
  })
  .catch((err) => {
    console.error("❌ Erreur MongoDB :", err.message);
  });
