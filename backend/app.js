const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const authRoutes = require("./routes/authRoutes");

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);

// Connexion à MongoDB Atlas
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("✅ MongoDB Atlas connecté");
    app.listen(process.env.PORT, () => {
      console.log("🚀 Serveur démarré sur le port", process.env.PORT);
    });
  })
  .catch((err) => {
    console.error("❌ Erreur de connexion MongoDB :", err.message);
  });
