import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart'; // 👈 package vibration

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
  bool isCalling = true;
  bool isMuted = false;
  bool isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    _startRingtoneVibration();
  }

  @override
  void dispose() {
    Vibration.cancel(); // stop vibration quand on quitte la page
    super.dispose();
  }

  /// Lance une vibration type sonnerie
  void _startRingtoneVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      List<int> pattern = [
        0, // délai avant de commencer
        500, // vibre 0.5s
        400,
        500, // vibre 0.5s
        2000,
      ];

      // repeat: 0 → recommence à l’index 0 = vibration infinie
      Vibration.vibrate(pattern: pattern, repeat: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFB744), Color(0xFFFF6464)],
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
                    ClipOval(
                      child: SvgPicture.asset(
                        widget.avatarPath,
                        width: 120,
                        height: 120,
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
                      icon: isMuted ? Icons.mic : Icons.mic_off,
                      color: isMuted
                          ? const Color.fromARGB(155, 33, 149, 243)
                          : const Color.fromARGB(150, 249, 168, 37)!,
                      onTap: () {
                        setState(() => isMuted = !isMuted);

                        _showModernSnackBar(
                          context,
                          isMuted ? "Micro activé" : "Micro coupé",
                          icon: isMuted ? Icons.mic : Icons.mic_off,
                          color: isMuted ? Colors.blue : Colors.blue[700]!,
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
                        Vibration.cancel(); // stop la vibration au raccrochage
                        Future.delayed(const Duration(milliseconds: 600), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const SizedBox(width: 30),

                    // Bouton haut-parleur
                    _buildActionButton(
                      icon: Icons.volume_up,
                      color: isSpeakerOn
                          ? Colors.green
                          : const Color.fromARGB(150, 249, 168, 37)!,
                      onTap: () {
                        setState(() => isSpeakerOn = !isSpeakerOn);

                        _showModernSnackBar(
                          context,
                          isSpeakerOn
                              ? "Haut-parleur activé"
                              : "Haut-parleur désactivé",
                          icon: Icons.volume_up,
                          color: isSpeakerOn ? Colors.green : Colors.grey[700]!,
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

  /// Widget bouton circulaire
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
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  /// SnackBar moderne et flottant
  void _showModernSnackBar(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color.withOpacity(0.9),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
