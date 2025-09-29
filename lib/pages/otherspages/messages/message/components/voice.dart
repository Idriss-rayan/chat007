import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Voice extends StatefulWidget {
  final Function(String path, int duration)? onRecorded;
  const Voice({super.key, this.onRecorded});

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    try {
      // Vérifie et demande la permission micro
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

      debugPrint("✅ Recorder initialisé avec succès");
    } catch (e) {
      debugPrint("❌ Erreur initialisation recorder: $e");
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || _isRecording) return;

    try {
      // Générer un nom de fichier unique avec timestamp
      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      _startTime = DateTime.now().millisecondsSinceEpoch;

      await _recorder.startRecorder(toFile: fileName);

      if (mounted) {
        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });
      }

      // Annuler tout timer existant
      _timer?.cancel();

      // Démarrer un nouveau timer
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
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderReady || !_isRecording) return;

    try {
      // Arrêter l'enregistrement
      String? path = await _recorder.stopRecorder();
      _timer?.cancel();

      // Calculer la durée exacte
      final int durationInSeconds = _recordDuration;

      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordDuration = 0;
        });
      }

      if (path != null) {
        debugPrint("✅ Enregistrement terminé:");
        debugPrint("📁 Fichier: $path");
        debugPrint("⏱️ Durée: ${durationInSeconds}s");

        // Appeler le callback avec le chemin et la durée
        widget.onRecorded?.call(path, durationInSeconds);
      } else {
        debugPrint("❌ Erreur: Chemin du fichier null");
      }
    } catch (e) {
      debugPrint("❌ Erreur arrêt enregistrement: $e");
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  Future<void> _cancelRecording() async {
    if (_isRecording) {
      _timer?.cancel();
      await _recorder.stopRecorder();

      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordDuration = 0;
        });
      }

      debugPrint("❌ Enregistrement annulé");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startRecording(),
      onTapUp: (_) => _stopRecording(),
      onTapCancel: _cancelRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red : Colors.orange,
          shape: BoxShape.circle,
        ),
        child: _isRecording
            ? SizedBox(
                height: 16,
                width: 16,
                child: SvgPicture.asset(
                  'assets/component/stop.svg',
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.mic,
                color: Colors.white,
                size: 20,
              ),
      ),
    );
  }
}
