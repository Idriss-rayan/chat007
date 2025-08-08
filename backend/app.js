const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes");
const Message = require("./models/message");

dotenv.config();

const app = express();
const server = http.createServer(app); // ✅ Utilise http.Server
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);

// ✅ Route GET pour les anciens messages
app.get("/api/messages", async (req, res) => {
  const { sender, receiver } = req.query;

  if (!sender || !receiver) {
    return res.status(400).json({ message: "Paramètres sender et receiver requis" });
  }

  try {
    const messages = await Message.find({
      $or: [
        { sender, receiver },
        { sender: receiver, receiver: sender }
      ]
    }).sort({ timestamp: 1 });

    res.json(messages);
  } catch (err) {
    console.error("❌ Erreur dans /api/messages :", err.message);
    res.status(500).json({ message: "Erreur serveur" });
  }
});


io.on("connection", (socket) => {
  console.log("⚡ Un utilisateur est connecté");

  socket.on("send_message", async (data) => {
    try {
      const { sender, receiver, text } = data;
      const message = new Message({ sender, receiver, text });
      await message.save();
      io.emit("receive_message", {
        sender,
        receiver,
        text,
        timestamp: message.timestamp,
      });
    } catch (err) {
      console.error("Erreur lors de l'envoi du message :", err.message);
    }
  });

  socket.on("disconnect", () => {
    console.log("👋 Utilisateur déconnecté");
  });
});

// Connexion à MongoDB + lancement serveur
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("✅ MongoDB connecté");
    const PORT = process.env.PORT || 5000;
    server.listen(PORT, () => {
      console.log(`🚀 Serveur lancé sur le port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("❌ Erreur MongoDB :", err.message);
  });
