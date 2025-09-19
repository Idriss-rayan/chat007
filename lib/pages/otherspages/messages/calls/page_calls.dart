import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageCalls extends StatefulWidget {
  final String name;
  final String avatarPath;

  const PageCalls({
    super.key,
    required this.name,
    this.avatarPath = 'assets/component/avatar.svg',
  });

  @override
  State<PageCalls> createState() => _PageCallsState();
}

class _PageCallsState extends State<PageCalls> {
  bool isCalling = true; // true = en appel, false = raccroché

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFB744), Color(0xFFFF6464)], // joli dégradé
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Haut → Avatar + Nom
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SvgPicture.asset(
                          widget.avatarPath,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCalling ? "Appel en cours..." : "Appel terminé",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              /// Bas → Boutons d’action
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton mute
                    _buildActionButton(
                      icon: Icons.mic_off,
                      color: Colors.grey[800]!,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: Text("Micro coupé")),
                            behavior: SnackBarBehavior
                                .floating, // 👈 le rend flottant
                            margin: const EdgeInsets.all(
                                16), // marges pour qu'il flotte
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // arrondi moderne
                            ),
                            backgroundColor:
                                const Color.fromARGB(153, 64, 195, 255),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 30),

                    // Bouton raccrocher
                    _buildActionButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      size: 70,
                      onTap: () {
                        setState(() => isCalling = false);
                        Future.delayed(const Duration(milliseconds: 600), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const SizedBox(width: 30),

                    // Bouton haut-parleur
                    _buildActionButton(
                      icon: Icons.volume_up,
                      color: Colors.grey[800]!,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Haut-parleur activé")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget réutilisable pour les boutons circulaires
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
