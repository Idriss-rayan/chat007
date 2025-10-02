import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  final String userName = "John Doe";
  final String phoneNumber = "+225 07 00 00 00 00";
  final String status = "Disponible";
  final String email = "john.doe@email.com";
  final String bio =
      "Développeur Flutter passionné | Amateur de technologies innovantes";
  final String joinDate = "Membre depuis Janvier 2024";
  final int totalContacts = 127;
  final int groupsCount = 15;
  final String lastSeen = "En ligne";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Modifier le profil",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepOrange),
                  title: const Text("Nom complet"),
                  subtitle: Text(userName),
                  onTap: () => _editField("Nom", userName),
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.deepOrange),
                  title: const Text("Statut"),
                  subtitle: Text(status),
                  onTap: () => _editField("Statut", status),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.deepOrange),
                  title: const Text("Email"),
                  subtitle: Text(email),
                  onTap: () => _editField("Email", email),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.description, color: Colors.deepOrange),
                  title: const Text("Bio"),
                  subtitle: Text(bio),
                  onTap: () => _editField("Bio", bio),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.photo_camera, color: Colors.deepOrange),
                  title: const Text("Photo de profil"),
                  onTap: _changeProfilePhoto,
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.deepOrange),
                  title: const Text("Numéro de téléphone"),
                  subtitle: Text(phoneNumber),
                  onTap: () => _editField("Téléphone", phoneNumber),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Sauvegarder les modifications
                Navigator.pop(context);
                _showSuccessSnackbar("Profil mis à jour avec succès");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
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

  void _editField(String field, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Modifier $field"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Entrez votre $field",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique de sauvegarde
                Navigator.pop(context);
                _showSuccessSnackbar("$field mis à jour");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text("Sauvegarder"),
            ),
          ],
        );
      },
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Changer la photo de profil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.deepOrange),
                title: const Text("Choisir depuis la galerie"),
                onTap: () {
                  Navigator.pop(context);
                  // Implémenter la sélection depuis la galerie
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.deepOrange),
                title: const Text("Prendre une photo"),
                onTap: () {
                  Navigator.pop(context);
                  // Implémenter la prise de photo
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: const Text("Supprimer la photo actuelle"),
                onTap: () {
                  Navigator.pop(context);
                  // Implémenter la suppression
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQrCode() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Votre QR Code",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(Icons.qr_code, size: 150, color: Colors.deepOrange),
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
                          foregroundColor: Colors.deepOrange,
                          side: BorderSide(color: Colors.deepOrange),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Fermer"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          // Partager le QR code
                          _showSuccessSnackbar("QR Code partagé");
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
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = Colors.deepOrange,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDestructive ? Colors.red.shade400 : Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepOrange.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.deepOrange),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2),
            onPressed: _showQrCode,
            tooltip: "QR Code",
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileDialog,
            tooltip: "Modifier le profil",
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideIn,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Photo de profil avec statistiques
                Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.deepOrange,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/component/avatar.png",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.deepOrange.shade100,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.deepOrange,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfilePhoto,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Nom et informations principales
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  joinDate,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                // Statistiques
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatCard(
                          "Contacts", "$totalContacts", Icons.contacts),
                      const SizedBox(width: 10),
                      _buildStatCard("Groupes", "$groupsCount", Icons.group),
                      const SizedBox(width: 10),
                      _buildStatCard(
                          "En ligne", lastSeen, Icons.online_prediction),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section informations personnelles
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Informations personnelles",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.phone,
                        title: "Téléphone",
                        subtitle: phoneNumber,
                        onTap: () {
                          _showContactActionSheet(
                              phoneNumber, "Numéro de téléphone");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.email,
                        title: "Email",
                        subtitle: email,
                        onTap: () {
                          _showContactActionSheet(email, "Adresse email");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.description,
                        title: "Bio",
                        subtitle: bio.length > 40
                            ? "${bio.substring(0, 40)}..."
                            : bio,
                        onTap: () => _editField("Bio", bio),
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.cake,
                        title: "Date d'anniversaire",
                        subtitle: "Non définie",
                        onTap: () => _editField("Anniversaire", "Non définie"),
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section paramètres
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Paramètres",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications,
                        title: "Notifications",
                        subtitle: "Personnaliser les notifications",
                        onTap: () {
                          _showSettingsPage("Notifications");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.lock,
                        title: "Confidentialité",
                        subtitle: "Contrôler votre vie privée",
                        onTap: () {
                          _showSettingsPage("Confidentialité");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.storage,
                        title: "Stockage et données",
                        subtitle: "Gérer l'espace de stockage",
                        onTap: () {
                          _showSettingsPage("Stockage");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.language,
                        title: "Langue",
                        subtitle: "Français",
                        onTap: () {
                          _showLanguageSelection();
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.help,
                        title: "Aide",
                        subtitle: "Centre d'aide et support",
                        onTap: () {
                          _showSettingsPage("Aide");
                        },
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section compte
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Compte",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.group_add,
                        title: "Inviter des amis",
                        subtitle: "Partager l'application",
                        onTap: () {
                          _showSuccessSnackbar("Lien d'invitation copié");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.security,
                        title: "Sécurité",
                        subtitle: "Verrouillage de l'application",
                        onTap: () {
                          _showSettingsPage("Sécurité");
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.backup,
                        title: "Sauvegarde",
                        subtitle: "Sauvegarder vos conversations",
                        onTap: () {
                          _showBackupOptions();
                        },
                        color: Colors.deepOrange,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.delete,
                        title: "Supprimer le compte",
                        subtitle: "Supprimer définitivement votre compte",
                        onTap: _showDeleteAccountDialog,
                        color: Colors.red,
                        isDestructive: true,
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      _buildMenuItem(
                        icon: Icons.exit_to_app,
                        title: "Déconnexion",
                        subtitle: "Se déconnecter de ce compte",
                        onTap: _showLogoutDialog,
                        color: Colors.red,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Version de l'application
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "SimpleChat v2.1.0",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Dernière mise à jour: 15 Mars 2024",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactActionSheet(String value, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        side: BorderSide(color: Colors.deepOrange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessSnackbar("Copié dans le presse-papier");
                      },
                      child: const Text("Copier"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Action de partage
                        _showSuccessSnackbar("$title partagé");
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

  void _showSettingsPage(String pageName) {
    // Navigation vers les pages de paramètres
    _showSuccessSnackbar("Ouverture de $pageName");
  }

  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Choisir la langue",
            style: TextStyle(color: Colors.deepOrange.shade700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: Colors.deepOrange),
                title: const Text("Français"),
                trailing: const Icon(Icons.check, color: Colors.deepOrange),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Langue changée en Français");
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.grey),
                title: const Text("English"),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Language changed to English");
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.grey),
                title: const Text("Español"),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Idioma cambiado a Español");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBackupOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sauvegarde des données",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading:
                    const Icon(Icons.cloud_upload, color: Colors.deepOrange),
                title: const Text("Sauvegarder sur le cloud"),
                subtitle: const Text("Dernière sauvegarde: 12 Mars 2024"),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Sauvegarde cloud démarrée");
                },
              ),
              ListTile(
                leading: const Icon(Icons.sd_storage, color: Colors.deepOrange),
                title: const Text("Sauvegarder localement"),
                subtitle: const Text("Exporter vers votre appareil"),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Sauvegarde locale démarrée");
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.deepOrange),
                title: const Text("Restaurer une sauvegarde"),
                subtitle: const Text("Importer depuis une sauvegarde"),
                onTap: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar("Restauration démarrée");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Supprimer le compte",
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            "Cette action est irréversible. Toutes vos données, conversations et contacts seront définitivement supprimés. Voulez-vous vraiment continuer ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackbar("Compte marqué pour suppression");
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Déconnexion"),
          content: const Text(
              "Voulez-vous vraiment vous déconnecter ? Vous devrez vous reconnecter pour utiliser l'application."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackbar("Déconnexion réussie");
                // Action de déconnexion réelle
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
