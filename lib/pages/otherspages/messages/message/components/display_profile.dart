import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/messages/calls/page_calls.dart';
import 'package:simplechat/pages/otherspages/messages/message/chat_discussion.dart';

class DisplayProfile extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String status;
  final String avatarPath;
  final bool isOnline;

  const DisplayProfile({
    super.key,
    required this.userName,
    required this.phoneNumber,
    this.status = "Hey there! I am using SimpleChat",
    this.avatarPath = 'assets/component/avatar.svg',
    this.isOnline = false,
  });

  @override
  State<DisplayProfile> createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  bool _isMuted = false;
  bool _isBlocked = false;

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Options principales
              _buildActionTile(
                icon: Icons.message,
                title: "Envoyer un message",
                subtitle: "Envoyer un message à ${widget.userName}",
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers le chat
                },
              ),
              _buildActionTile(
                icon: Icons.call,
                title: "Appeler",
                subtitle: "Appeler ${widget.userName}",
                onTap: () {
                  Navigator.pop(context);
                  // Action d'appel
                },
              ),
              _buildActionTile(
                icon: Icons.videocam,
                title: "Appel vidéo",
                subtitle: "Appel vidéo avec ${widget.userName}",
                onTap: () {
                  Navigator.pop(context);
                  // Action d'appel vidéo
                },
              ),
              const SizedBox(height: 8),

              // Options de réglages
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: "Notifications",
                      subtitle: _isMuted
                          ? "Notifications désactivées"
                          : "Notifications activées",
                      value: !_isMuted,
                      onChanged: (value) {
                        setState(() {
                          _isMuted = !value;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    _buildDivider(),
                    _buildActionTile(
                      icon: Icons.block,
                      title: _isBlocked ? "Débloquer" : "Bloquer",
                      subtitle: _isBlocked
                          ? "Débloquer ${widget.userName}"
                          : "Bloquer ${widget.userName}",
                      color: _isBlocked ? Colors.green : Colors.red,
                      onTap: () {
                        setState(() {
                          _isBlocked = !_isBlocked;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    _buildDivider(),
                    _buildActionTile(
                      icon: Icons.report,
                      title: "Signaler",
                      subtitle: "Signaler ${widget.userName}",
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        _showReportDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Bouton annuler
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Colors.grey.shade300,
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Signaler l'utilisateur"),
          content: const Text(
            "Voulez-vous vraiment signaler cet utilisateur ? "
            "Cette action ne peut pas être annulée.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Utilisateur signalé avec succès"),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text(
                "Signaler",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profil",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showActionSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Photo de profil
            Center(
              child: Hero(
                tag: "profile_${widget.userName}",
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          widget.avatarPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (widget.isOnline)
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nom et informations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.phoneNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.status,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Informations supplémentaires
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
                children: [
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: "Appeler le mobile",
                    subtitle: widget.phoneNumber,
                    onTap: () {
                      // Action d'appel
                    },
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.email,
                    title: "Email",
                    subtitle:
                        "${widget.userName.toLowerCase().replaceAll(' ', '.')}@email.com",
                    onTap: () {
                      // Action email
                    },
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: "Localisation",
                    subtitle: "Abidjan, Côte d'Ivoire",
                    onTap: () {
                      // Action localisation
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Statistiques
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statistiques",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          value: "1,234",
                          label: "Messages",
                        ),
                        _buildStatItem(
                          value: "45",
                          label: "Photos",
                        ),
                        _buildStatItem(
                          value: "12",
                          label: "Vidéos",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),

      // Boutons d'action en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.top: BorderSide(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.message, size: 20, color: Colors.black),
                label: const Text(
                  "Message",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ChatDiscussion(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.call, size: 20, color: Colors.black),
                label: const Text(
                  "Appeler",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PageCalls(
                        name: 'rayan',
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
