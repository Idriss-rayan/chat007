// profile_dialogs.dart
import 'package:flutter/material.dart';
import 'profile_colors.dart';
import 'profile_widgets.dart';

class ProfileDialogs {
  static void showEditProfileDialog(
    BuildContext context, {
    required String userName,
    required String status,
    required String email,
    required String bio,
    required String phoneNumber,
    required Function(String) onEditField,
    required Function() onChangePhoto,
    required Function() onSuccess,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Modifier le profil",
            style: TextStyle(
              color: ProfileColors.primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileWidgets.buildEditOption(Icons.person, "Nom complet",
                    userName, () => onEditField("Nom complet")),
                ProfileWidgets.buildEditOption(
                    Icons.info, "Statut", status, () => onEditField("Statut")),
                ProfileWidgets.buildEditOption(
                    Icons.email, "Email", email, () => onEditField("Email")),
                ProfileWidgets.buildEditOption(
                    Icons.description, "Bio", bio, () => onEditField("Bio")),
                ProfileWidgets.buildEditOption(
                    Icons.photo_camera, "Photo de profil", "", onChangePhoto),
                // ProfileWidgets.buildEditOption(
                //     Icons.phone,
                //     "Numéro de téléphone",
                //     phoneNumber,
                //     () => onEditField("Téléphone")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annuler",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSuccess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Sauvegarder",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showEditFieldDialog(
    BuildContext context, {
    required String field,
    required String currentValue,
    required Function() onSuccess,
  }) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Modifier $field",
            style: TextStyle(
              color: ProfileColors.primaryOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Entrez votre $field",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: ProfileColors.lightOrange.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ProfileColors.primaryOrange),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annuler",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSuccess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text("Sauvegarder"),
            ),
          ],
        );
      },
    );
  }

  static void showQrCodeDialog(
    BuildContext context, {
    required String userName,
    required String phoneNumber,
    required Function() onShare,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ProfileColors.white,
                  ProfileColors.lightPink.withOpacity(0.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Votre QR Code",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ProfileColors.primaryOrange,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ProfileColors.lightOrange.withOpacity(0.1),
                        ProfileColors.pink.withOpacity(0.1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ProfileColors.lightOrange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(Icons.qr_code,
                      size: 120, color: ProfileColors.primaryOrange),
                ),
                const SizedBox(height: 20),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Scannez pour ajouter en contact",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ProfileColors.primaryOrange,
                          side: BorderSide(
                              color: ProfileColors.primaryOrange, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Fermer"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProfileColors.primaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: onShare,
                        child: const Text(
                          "Partager",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showLanguageSelectionDialog(
      BuildContext context, Function(String) onLanguageSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Choisir la langue",
            style: TextStyle(color: ProfileColors.primaryOrange),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileWidgets.buildLanguageOption("Français", true, () {
                Navigator.pop(context);
                onLanguageSelected("Français");
              }),
              ProfileWidgets.buildLanguageOption("English", false, () {
                Navigator.pop(context);
                onLanguageSelected("English");
              }),
              ProfileWidgets.buildLanguageOption("Español", false, () {
                Navigator.pop(context);
                onLanguageSelected("Español");
              }),
            ],
          ),
        );
      },
    );
  }

  static void showDeleteAccountDialog(
      BuildContext context, Function() onDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Supprimer le compte",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Cette action est irréversible. Toutes vos données, conversations et contacts seront définitivement supprimés. Voulez-vous vraiment continuer ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annuler",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showLogoutDialog(BuildContext context, Function() onLogout) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ProfileColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Déconnexion",
              style: TextStyle(color: ProfileColors.primaryOrange)),
          content: const Text(
              "Voulez-vous vraiment vous déconnecter ? Vous devrez vous reconnecter pour utiliser l'application."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annuler",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              },
              child: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
