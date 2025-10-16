import db from "../config/db.js";

export const findUserByEmail = (email, callback) => {
    db.query("SELECT * FROM users WHERE email = ?", [email], callback);
};

export const createUser = (user, callback) => {
    db.query("INSERT INTO users SET ?", user, callback);
};
