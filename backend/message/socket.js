const Message = require("./models/Message");

io.on("connection", (socket) => {
  console.log("Un utilisateur est connecté");

  socket.on("send_message", async (data) => {
    const { sender, receiver, text } = data;

    // 1. Sauvegarder dans MongoDB
    const message = new Message({ sender, receiver, text });
    await message.save();

    // 2. Émettre à tous (ou à un canal privé selon ton app)
    io.emit("receive_message", data);
  });
});
