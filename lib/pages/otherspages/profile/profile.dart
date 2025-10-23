// profile.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_colors.dart';
import 'profile_widgets.dart';
import 'profile_dialogs.dart';
import 'profile_bottom_sheets.dart';
import 'profile_api.dart'; // 👈 Nouveau import

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  // Variables pour stocker les données du backend
  Map<String, dynamic> _userProfile = {};
  Map<String, dynamic> _userStats = {};
  bool _isLoading = true;
  String _errorMessage = '';

  // Données par défaut (utilisées en attendant le chargement)
  String get userName {
    final firstName = _userProfile['first_name'] ?? '';
    final lastName = _userProfile['last_name'] ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    } else {
      return _userProfile['username'] ??
          _userProfile['userName'] ??
          "Non spécifié";
    }
  }

  String get phoneNumber =>
      _userProfile['phoneNumber'] ?? "+225 07 00 00 00 00";
  String get status =>
      _userProfile['isOnline'] == true ? "En ligne" : "En ligne";
  String get email => _userProfile['email'] ?? "john.doe@email.com";
  String get bio =>
      _userProfile['bio'] ??
      "Développeur Flutter passionné | Amateur de technologies innovantes";
  String get joinDate =>
      _formatJoinDate(_userProfile['joinDate']) ?? "Membre depuis Janvier 2024";
  String get country => _userProfile['country'] ?? "Côte d'Ivoire";
  String get city => _userProfile['city'] ?? "Abidjan";

  int get totalContacts => _userStats['totalContacts'] ?? 127;
  int get groupsCount => _userStats['groupsCount'] ?? 15;
  String get lastSeen => _userStats['lastSeen'] ?? "En ligne";

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

    // Charger les données du profil
    _loadProfileData();
  }

  // Fonction pour charger les données du profil
  Future<void> _loadProfileData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Récupérer l'ID utilisateur depuis le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Décoder le token pour obtenir l'ID utilisateur
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Token invalide');
      }

      String normalized = parts[1];
      switch (normalized.length % 4) {
        case 2:
          normalized += '==';
          break;
        case 3:
          normalized += '=';
          break;
      }

      final payload = json.decode(utf8.decode(base64Url.decode(normalized)));

      final userId = payload['id'];

      if (userId == null) {
        throw Exception('ID utilisateur non trouvé');
      }

      // Charger le profil et les statistiques en parallèle
      final [profileData, statsData] = await Future.wait([
        ProfileApi.getUserProfile(),
        ProfileApi.getUserStats(userId),
      ]);

      setState(() {
        _userProfile = profileData;
        _userStats = statsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
      print('Erreur chargement profil: $e');
    }
  }

  // Formater la date d'inscription
  String _formatJoinDate(dynamic date) {
    if (date == null) return "Membre depuis Janvier 2024";

    try {
      final DateTime joinDate = DateTime.parse(date.toString());
      final months = [
        'Janvier',
        'Février',
        'Mars',
        'Avril',
        'Mai',
        'Juin',
        'Juillet',
        'Août',
        'Septembre',
        'Octobre',
        'Novembre',
        'Décembre'
      ];
      return "Membre depuis ${months[joinDate.month - 1]} ${joinDate.year}";
    } catch (e) {
      return "Membre depuis Janvier 2024";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ProfileColors.primaryOrange,
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSettingsPage(String pageName) {
    _showSuccessSnackbar("Ouverture de $pageName");
  }

  // Afficher un indicateur de chargement
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(ProfileColors.primaryOrange),
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement du profil...',
            style: TextStyle(
              color: ProfileColors.primaryOrange,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Afficher un message d'erreur
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadProfileData,
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfileColors.primaryOrange,
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ProfileColors.white,
          foregroundColor: ProfileColors.primaryOrange,
          elevation: 0,
          title: Text(
            "Profil",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ProfileColors.primaryOrange,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildLoadingIndicator(),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ProfileColors.white,
          foregroundColor: ProfileColors.primaryOrange,
          elevation: 0,
          title: Text(
            "Profil",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: ProfileColors.primaryOrange,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildErrorWidget(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ProfileColors.white,
        foregroundColor: ProfileColors.primaryOrange,
        elevation: 0,
        title: Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ProfileColors.primaryOrange,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_2, color: ProfileColors.primaryOrange),
            onPressed: () => ProfileDialogs.showQrCodeDialog(
              context,
              userName: userName,
              phoneNumber: phoneNumber,
              onShare: () => _showSuccessSnackbar("QR Code partagé"),
            ),
            tooltip: "QR Code",
          ),
          IconButton(
            icon: Icon(Icons.edit, color: ProfileColors.primaryOrange),
            onPressed: () => ProfileDialogs.showEditProfileDialog(
              context,
              userName: userName,
              status: status,
              email: email,
              bio: bio,
              phoneNumber: phoneNumber,
              onEditField: (field) => ProfileDialogs.showEditFieldDialog(
                context,
                field: field,
                currentValue: _getCurrentValue(field),
                onSuccess: () {
                  _showSuccessSnackbar("$field mis à jour");
                  // Recharger les données après modification
                  _loadProfileData();
                },
              ),
              onChangePhoto: _changeProfilePhoto,
              onSuccess: () {
                _showSuccessSnackbar("Profil mis à jour avec succès");
                // Recharger les données après modification
                _loadProfileData();
              },
            ),
            tooltip: "Modifier le profil",
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfileData,
        child: ListView(
          children: [
            Column(
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
                        gradient: ProfileColors.mainGradient,
                        boxShadow: [
                          BoxShadow(
                            color: ProfileColors.primaryOrange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: _userProfile['avatar_url'] != null
                              ? Image.network(
                                  _userProfile['avatar_url'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                )
                              : _buildDefaultAvatar(),
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
                            gradient: ProfileColors.buttonGradient,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ProfileColors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ProfileColors.primaryOrange
                                    .withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: ProfileColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Nom et informations principales
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                // Text(
                //   phoneNumber,
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.grey.shade600,
                //   ),
                // ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ProfileColors.lightOrange.withOpacity(0.1),
                        ProfileColors.pink.withOpacity(0.1)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ProfileColors.lightOrange.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: ProfileColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  joinDate,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 24),

                // Statistiques
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ProfileWidgets.buildStatCard(
                          "Contacts", "$totalContacts", Icons.contacts),
                      const SizedBox(width: 12),
                      ProfileWidgets.buildStatCard(
                          "Groupes", "$groupsCount", Icons.group),
                      const SizedBox(width: 12),
                      ProfileWidgets.buildStatCard(
                          "En ligne", lastSeen, Icons.online_prediction),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section informations personnelles
                ProfileWidgets.buildSection(
                  title: "Informations personnelles",
                  children: [
                    // ProfileWidgets.buildMenuItem(
                    //   icon: Icons.phone,
                    //   title: "Téléphone",
                    //   subtitle: phoneNumber,
                    //   onTap: () => ProfileBottomSheets.showContactActionSheet(
                    //     context,
                    //     value: phoneNumber,
                    //     title: "Numéro de téléphone",
                    //     onCopy: () =>
                    //         _showSuccessSnackbar("Copié dans le presse-papier"),
                    //     onShare: () =>
                    //         _showSuccessSnackbar("Numéro de téléphone partagé"),
                    //   ),
                    // ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.email,
                      title: "Email",
                      subtitle: email,
                      onTap: () => ProfileBottomSheets.showContactActionSheet(
                        context,
                        value: email,
                        title: "Adresse email",
                        onCopy: () =>
                            _showSuccessSnackbar("Copié dans le presse-papier"),
                        onShare: () =>
                            _showSuccessSnackbar("Adresse email partagée"),
                      ),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.description,
                      title: "Bio",
                      subtitle:
                          bio.length > 40 ? "${bio.substring(0, 40)}..." : bio,
                      onTap: () => ProfileDialogs.showEditFieldDialog(
                        context,
                        field: "Bio",
                        currentValue: bio,
                        onSuccess: () {
                          _showSuccessSnackbar("Bio mis à jour");
                          _loadProfileData();
                        },
                      ),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.location_on,
                      title: "Localisation",
                      subtitle: "$city, $country",
                      onTap: () => ProfileDialogs.showEditFieldDialog(
                        context,
                        field: "Localisation",
                        currentValue: "$city, $country",
                        onSuccess: () {
                          _showSuccessSnackbar("Localisation mise à jour");
                          _loadProfileData();
                        },
                      ),
                    ),
                  ],
                ),

                // ... Le reste de votre interface reste inchangé ...
                const SizedBox(height: 20),

                // Section paramètres
                ProfileWidgets.buildSection(
                  title: "Paramètres",
                  children: [
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.notifications,
                      title: "Notifications",
                      subtitle: "Personnaliser les notifications",
                      onTap: () => _showSettingsPage("Notifications"),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.lock,
                      title: "Confidentialité",
                      subtitle: "Contrôler votre vie privée",
                      onTap: () => _showSettingsPage("Confidentialité"),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.storage,
                      title: "Stockage et données",
                      subtitle: "Gérer l'espace de stockage",
                      onTap: () => _showSettingsPage("Stockage"),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.language,
                      title: "Langue",
                      subtitle: "Français",
                      onTap: () => ProfileDialogs.showLanguageSelectionDialog(
                        context,
                        (language) =>
                            _showSuccessSnackbar("Langue changée en $language"),
                      ),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.help,
                      title: "Aide",
                      subtitle: "Centre d'aide et support",
                      onTap: () => _showSettingsPage("Aide"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Section compte
                ProfileWidgets.buildSection(
                  title: "Compte",
                  children: [
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.group_add,
                      title: "Inviter des amis",
                      subtitle: "Partager l'application",
                      onTap: () =>
                          _showSuccessSnackbar("Lien d'invitation copié"),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.security,
                      title: "Sécurité",
                      subtitle: "Verrouillage de l'application",
                      onTap: () => _showSettingsPage("Sécurité"),
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.backup,
                      title: "Sauvegarde",
                      subtitle: "Sauvegarder vos conversations",
                      onTap: _showBackupOptions,
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.delete,
                      title: "Supprimer le compte",
                      subtitle: "Supprimer définitivement votre compte",
                      onTap: () => ProfileDialogs.showDeleteAccountDialog(
                        context,
                        () => _showSuccessSnackbar(
                            "Compte marqué pour suppression"),
                      ),
                      isDestructive: true,
                    ),
                    ProfileWidgets.buildMenuItem(
                      icon: Icons.exit_to_app,
                      title: "Déconnexion",
                      subtitle: "Se déconnecter de ce compte",
                      onTap: () => ProfileDialogs.showLogoutDialog(
                        context,
                        () async {
                          await logout(context);
                          _showSuccessSnackbar("Déconnexion réussie");
                        },
                      ),
                      isDestructive: true,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Version de l'application
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "Papachou v2.0",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last release: 15 October 2025",
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
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: ProfileColors.lightPink.withOpacity(0.2),
      child: Icon(
        Icons.person,
        size: 60,
        color: ProfileColors.primaryOrange,
      ),
    );
  }

  String _getCurrentValue(String field) {
    switch (field) {
      case "Nom complet":
        return userName;
      case "Statut":
        return status;
      case "Email":
        return email;
      case "Bio":
        return bio;
      // case "Téléphone":
      //   return phoneNumber;
      case "Localisation":
        return "$city, $country";
      default:
        return "";
    }
  }

  void _changeProfilePhoto() {
    ProfileBottomSheets.showChangePhotoBottomSheet(
      context,
      onGallery: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Photo modifiée");
      },
      onCamera: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Photo modifiée");
      },
      onDelete: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Photo supprimée");
      },
    );
  }

  void _showBackupOptions() {
    ProfileBottomSheets.showBackupOptionsBottomSheet(
      context,
      onCloudBackup: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Sauvegarde cloud démarrée");
      },
      onLocalBackup: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Sauvegarde locale démarrée");
      },
      onRestore: () {
        Navigator.pop(context);
        _showSuccessSnackbar("Restauration démarrée");
      },
    );
  }
}
