import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioMsg extends StatefulWidget {
  final String path;
  final int duration;
  final Color color;
  final double height;

  const AudioMsg({
    super.key,
    required this.path,
    required this.duration,
    this.color = Colors.orange,
    this.height = 6,
  });

  @override
  State<AudioMsg> createState() => _AudioMsgState();
}

class _AudioMsgState extends State<AudioMsg>
    with SingleTickerProviderStateMixin {
  late FlutterSoundPlayer _player;
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    _player = FlutterSoundPlayer();
    _initializePlayer();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.openPlayer();
      setState(() {
        _isPlayerReady = true;
      });
    } catch (e) {
      debugPrint("❌ Erreur initialisation player: $e");
    }
  }

  @override
  void didUpdateWidget(covariant AudioMsg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = Duration(seconds: widget.duration);
    }
  }

  void _togglePlay() async {
    if (!_isPlayerReady) return;

    if (!_isPlaying) {
      try {
        // Démarrer la lecture
        await _player.startPlayer(
          fromURI: widget.path,
          codec: Codec.aacADTS,
          whenFinished: () {
            if (mounted) {
              setState(() {
                _isPlaying = false;
                _controller.reset();
              });
            }
          },
        );

        // Démarrer l'animation
        _controller.forward(from: 0);

        setState(() {
          _isPlaying = true;
        });
      } catch (e) {
        debugPrint("❌ Erreur lecture audio: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de la lecture audio")),
          );
        }
      }
    } else {
      // Arrêter la lecture
      await _player.stopPlayer();
      _controller.stop();

      setState(() {
        _isPlaying = false;
      });
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _player.closePlayer();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _isPlayerReady ? _togglePlay : null,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: _isPlayerReady ? widget.color : Colors.grey,
            ),
            iconSize: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de progression
                SizedBox(
                  height: widget.height,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          // Fond de la barre
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Progression
                          FractionallySizedBox(
                            widthFactor: _controller.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                // Durée
                Text(
                  _formatDuration(widget.duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
