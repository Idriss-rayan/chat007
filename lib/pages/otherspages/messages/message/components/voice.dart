import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class Voice extends StatefulWidget {
  const Voice({super.key});

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderReady = false;
  bool _isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    // Vérifie et demande la permission micro
    var status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      debugPrint("❌ Permission micro refusée");
      return;
    }

    await _recorder.openRecorder();
    setState(() {
      _isRecorderReady = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady) return;

    await _recorder.startRecorder(toFile: 'voice.aac');
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderReady) return;

    String? path = await _recorder.stopRecorder();
    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _recordDuration = 0;
    });

    if (path != null) {
      debugPrint("🎤 Fichier audio enregistré : $path");
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _startRecording,
          onTapCancel: _stopRecording,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),

        // Minuteur affiché uniquement quand ça enregistre
        if (_isRecording)
          Positioned(
            bottom: 4,
            child: Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
