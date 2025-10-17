import app from "./src/app.js";

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`🚀 Serveur démarré sur http://0.0.0.0:${PORT}`));

