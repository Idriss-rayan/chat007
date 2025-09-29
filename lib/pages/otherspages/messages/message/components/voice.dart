import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Voice extends StatefulWidget {
  final Function(String path, int duration)? onRecorded;
  final Function(String path, int duration)? onPreview;
  final VoidCallback?
      onRecordingStarted; // Nouveau callback pour le début d'enregistrement
  const Voice(
      {super.key, this.onRecorded, this.onPreview, this.onRecordingStarted});

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;
  int _startTime = 0;
  String? _lastRecordedPath;
  int? _lastRecordedDuration;

  // Animation controller pour le grossissement
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialisation de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0, // taille normale
      end: 1.5, // taille agrandie (50% plus gros)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _initRecorder();
  }

  Future<void> _initRecorder() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        debugPrint("❌ Permission micro refusée");
        return;
      }

      await _recorder.openRecorder();

      if (mounted) {
        setState(() {
          _isRecorderReady = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur initialisation recorder: $e");
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || _isRecording) return;

    try {
      // Démarrer l'animation de grossissement
      _animationController.forward();

      // Notifier le parent que l'enregistrement a démarré
      widget.onRecordingStarted?.call();

      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      _startTime = DateTime.now().millisecondsSinceEpoch;

      await _recorder.startRecorder(toFile: fileName);

      if (mounted) {
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _lastRecordedPath = null;
        });
      }

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordDuration =
                (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;
          });
        }
      });

      debugPrint("🎤 Début enregistrement: $fileName");
    } catch (e) {
      debugPrint("❌ Erreur démarrage enregistrement: $e");
      _animationController.reverse(); // Annuler l'animation en cas d'erreur
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderReady || !_isRecording) return;

    try {
      // Arrêter l'animation
      _animationController.reverse();

      String? path = await _recorder.stopRecorder();
      _timer?.cancel();

      final int durationInSeconds = _recordDuration;

      if (mounted) {
        setState(() {
          _isRecording = false;
          _lastRecordedPath = path;
          _lastRecordedDuration = durationInSeconds;
        });
      }

      if (path != null) {
        debugPrint("✅ Enregistrement terminé - Durée: ${durationInSeconds}s");
        widget.onPreview?.call(path, durationInSeconds);
      }
    } catch (e) {
      debugPrint("❌ Erreur arrêt enregistrement: $e");
      _animationController.reverse();
    }
  }

  void _sendRecording() {
    if (_lastRecordedPath != null && _lastRecordedDuration != null) {
      widget.onRecorded?.call(_lastRecordedPath!, _lastRecordedDuration!);

      if (mounted) {
        setState(() {
          _lastRecordedPath = null;
          _lastRecordedDuration = null;
        });
      }
    }
  }

  void _cancelRecording() {
    if (_isRecording) {
      // Arrêter l'animation
      _animationController.reverse();

      _timer?.cancel();
      _recorder.stopRecorder();

      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordDuration = 0;
          _lastRecordedPath = null;
        });
      }
      debugPrint("❌ Enregistrement annulé");
    } else if (_lastRecordedPath != null) {
      if (mounted) {
        setState(() {
          _lastRecordedPath = null;
          _lastRecordedDuration = null;
        });
      }
      debugPrint("❌ Prévisualisation annulée");
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si on a un audio en prévisualisation, afficher les boutons d'action
    if (_lastRecordedPath != null) {
      return _buildPreviewActions();
    }

    // Bouton d'enregistrement avec animation de scale
    return GestureDetector(
      onTapDown: (_) => _startRecording(),
      onTapUp: (_) => _stopRecording(),
      onTapCancel: _cancelRecording,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  if (_isRecording)
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icone principale
                  _isRecording
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color.fromARGB(45, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 24,
                        ),

                  // Animation de pulsation pendant l'enregistrement
                  if (_isRecording)
                    ...List.generate(3, (index) => _buildPulse(index)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget pour l'animation de pulsation
  Widget _buildPulse(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1500 + (index * 300)),
      curve: Curves.easeInOut,
      width: _isRecording ? 70.0 : 50.0,
      height: _isRecording ? 70.0 : 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Colors.red.withOpacity(_isRecording ? 0.2 - (index * 0.05) : 0.0),
      ),
    );
  }

  // Widget pour les boutons de prévisualisation
  Widget _buildPreviewActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton écouter
          IconButton(
            onPressed: () {
              if (_lastRecordedPath != null && _lastRecordedDuration != null) {
                widget.onPreview
                    ?.call(_lastRecordedPath!, _lastRecordedDuration!);
              }
            },
            icon: const Icon(Icons.play_arrow, color: Colors.green, size: 20),
            tooltip: "Écouter l'audio",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Durée de l'audio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              _formatDuration(_lastRecordedDuration ?? 0),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          // Bouton envoyer
          IconButton(
            onPressed: _sendRecording,
            icon: const Icon(Icons.send, color: Colors.green, size: 18),
            tooltip: "Envoyer l'audio",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Bouton annuler
          IconButton(
            onPressed: _cancelRecording,
            icon: const Icon(Icons.close, color: Colors.red, size: 18),
            tooltip: "Supprimer l'audio",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
