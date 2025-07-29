const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const authRoutes = require("./routes/authRoutes");
const { createServer } = require("http");
const { Server } = require("socket.io");

dotenv.config();

const app = express();
const httpServer = createServer(app); // 🔁 Création du serveur HTTP
const io = new Server(httpServer, {
  cors: {
    origin: "*", // à sécuriser plus tard
    methods: ["GET", "POST"]
  }
});

// Middlewares
app.use(cors());
app.use(express.json());

// Routes API REST
app.use("/api/auth", authRoutes);

// 🔌 Socket.IO
io.on("connection", (socket) => {
  console.log("🟢 Utilisateur connecté :", socket.id);

  socket.on("send_message", (data) => {
    console.log("📩 Message reçu :", data);
    socket.broadcast.emit("receive_message", data); // Renvoie à tous sauf l’émetteur
  });

  socket.on("disconnect", () => {
    console.log("🔴 Utilisateur déconnecté :", socket.id);
  });
});

// Connexion à MongoDB et lancement du serveur
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("✅ MongoDB Atlas connecté");
    const PORT = process.env.PORT || 5000;
    httpServer.listen(PORT, () => {
      console.log("🚀 Serveur démarré sur le port", PORT);
    });
  })
  .catch((err) => {
    console.error("❌ Erreur de connexion MongoDB :", err.message);
  });
