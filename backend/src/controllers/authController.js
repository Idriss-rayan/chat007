import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { findUserByEmail, createUser } from "../models/userModel.js";

export const register = (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password)
        return res.status(400).json({ message: "Tous les champs sont requis" });

    findUserByEmail(email, (err, results) => {
        if (results.length > 0)
            return res.status(400).json({ message: "Email déjà utilisé" });

        const hashedPassword = bcrypt.hashSync(password, 10);
        createUser({ name, email, password: hashedPassword }, (err, result) => {
            if (err) {
                console.error(err); // Affiche l'erreur complète dans la console
                return res.status(500).json({ message: err.sqlMessage });
            }
            res.status(201).json({ message: "Utilisateur créé avec succès" });
        });
    });
};

export const login = (req, res) => {
    const { email, password } = req.body;

    findUserByEmail(email, (err, results) => {
        if (results.length === 0)
            return res.status(404).json({ message: "Utilisateur non trouvé" });

        const user = results[0];
        const isMatch = bcrypt.compareSync(password, user.password);

        if (!isMatch)

            return res.status(401).json({ message: "Mot de passe incorrect" });

        const token = jwt.sign(
            { id: user.id, email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: "1h" }
        );

        res.json({ message: "Connexion réussie", token });
    });
};
