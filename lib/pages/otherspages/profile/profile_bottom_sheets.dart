// profile_bottom_sheets.dart
import 'package:flutter/material.dart';
import 'profile_colors.dart';
import 'profile_widgets.dart';

class ProfileBottomSheets {
  static void showChangePhotoBottomSheet(
    BuildContext context, {
    required Function() onGallery,
    required Function() onCamera,
    required Function() onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ProfileColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ProfileColors.white,
                ProfileColors.lightPink.withOpacity(0.05)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Changer la photo de profil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ProfileColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 20),
              ProfileWidgets.buildPhotoOption(
                  Icons.photo_library,
                  "Choisir depuis la galerie",
                  ProfileColors.primaryOrange,
                  onGallery),
              ProfileWidgets.buildPhotoOption(Icons.camera_alt,
                  "Prendre une photo", ProfileColors.primaryOrange, onCamera),
              ProfileWidgets.buildPhotoOption(Icons.delete,
                  "Supprimer la photo actuelle", Colors.red, onDelete),
            ],
          ),
        );
      },
    );
  }

  static void showContactActionSheet(
    BuildContext context, {
    required String value,
    required String title,
    required Function() onCopy,
    required Function() onShare,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ProfileColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ProfileColors.white,
                ProfileColors.lightPink.withOpacity(0.05)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ProfileColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ProfileColors.lightPink.withOpacity(0.1),
                      ProfileColors.lightOrange.withOpacity(0.1)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ProfileColors.lightOrange.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
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
                      onPressed: () {
                        Navigator.pop(context);
                        onCopy();
                      },
                      child: const Text("Copier"),
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
                      onPressed: () {
                        Navigator.pop(context);
                        onShare();
                      },
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
        );
      },
    );
  }

  static void showBackupOptionsBottomSheet(
    BuildContext context, {
    required Function() onCloudBackup,
    required Function() onLocalBackup,
    required Function() onRestore,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ProfileColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ProfileColors.white,
                ProfileColors.lightPink.withOpacity(0.05)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Sauvegarde des données",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ProfileColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 20),
              ProfileWidgets.buildBackupOption(
                  Icons.cloud_upload,
                  "Sauvegarder sur le cloud",
                  "Dernière sauvegarde: 12 Mars 2024",
                  onCloudBackup),
              ProfileWidgets.buildBackupOption(
                  Icons.sd_storage,
                  "Sauvegarder localement",
                  "Exporter vers votre appareil",
                  onLocalBackup),
              ProfileWidgets.buildBackupOption(
                  Icons.restore,
                  "Restaurer une sauvegarde",
                  "Importer depuis une sauvegarde",
                  onRestore),
            ],
          ),
        );
      },
    );
  }
}
