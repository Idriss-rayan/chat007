import jwt from "jsonwebtoken";

export const verifyToken = (req, res, next) => {
    const token = req.headers["authorization"];

    if (!token)
        return res.status(403).json({ message: "Token manquant" });

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded; // tu pourras accéder à req.user.id dans tes routes
        next();
    } catch (err) {
        res.status(401).json({ message: "Token invalide ou expiré" });
    }
};
