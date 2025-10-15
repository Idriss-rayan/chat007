import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpacesPage extends StatefulWidget {
  final String name;
  final double duration;
  final double limit;

  const SpacesPage({
    super.key,
    required this.name,
    required this.duration,
    required this.limit,
  });

  @override
  State<SpacesPage> createState() => _SpacesPageState();
}

class _SpacesPageState extends State<SpacesPage> {
  List<Map<String, dynamic>> speakers = [
    {'name': 'Rayan', 'avatar': '👨‍💻', 'time': 3.2},
    {'name': 'Amina', 'avatar': '🎤', 'time': 2.1},
  ];

  List<Map<String, dynamic>> listeners = [
    {'name': 'Youssef', 'avatar': '🧑🏽‍💻'},
    {'name': 'Fatima', 'avatar': '👩🏻‍💼'},
    {'name': 'Ali', 'avatar': '🧔🏾'},
    {'name': 'Sana', 'avatar': '👩🏽‍🎓'},
  ];

  bool isSpaceActive = true;
  DateTime startTime = DateTime.now();

  String getDurationText() {
    final diff = DateTime.now().difference(startTime);
    return DateFormat('mm:ss').format(DateTime(0, 0, 0).add(diff));
  }

  void _toggleSpeakerStatus(Map<String, dynamic> user) {
    setState(() {
      if (speakers.contains(user)) {
        speakers.remove(user);
        listeners.add(user);
      } else {
        listeners.remove(user);
        speakers.add({...user, 'time': 0.0});
      }
    });
  }

  void _blockUser(Map<String, dynamic> user) {
    setState(() {
      speakers.remove(user);
      listeners.remove(user);
    });
  }

  void _stopSpace() {
    setState(() {
      isSpaceActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.deepOrangeAccent.shade100,
        centerTitle: true,
        title: Text(
          'Espace : ${widget.name.toUpperCase()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_voice_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: isSpaceActive
          ? RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info du Space
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _infoTile('Durée', '${widget.duration.round()} min',
                              Icons.timer),
                          _infoTile('Limite', '${widget.limit.round()} pers',
                              Icons.people),
                          _infoTile(
                              'En direct', getDurationText(), Icons.podcasts),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Speakers
                    Text(
                      '🎙️ Speakers (${speakers.length})',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                    ),
                    const SizedBox(height: 10),
                    _buildGrid(speakers, true),

                    const SizedBox(height: 20),

                    // Section Listeners
                    Text(
                      '👂 Listeners (${listeners.length})',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    _buildGrid(listeners, false),

                    const SizedBox(height: 30),

                    // Boutons d’action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (listeners.isNotEmpty) {
                              _toggleSpeakerStatus(listeners.first);
                            }
                          },
                          icon: const Icon(Icons.mic),
                          label: const Text('Inviter Speaker'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _stopSpace,
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: const Text('Arrêter Space'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: Text(
                  'Le Space "${widget.name}" est terminé 🚫',
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
    );
  }

  // --- Widgets réutilisables ---

  Widget _infoTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrangeAccent),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> users, bool isSpeaker) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.9),
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: () => _showUserOptions(user),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor:
                    isSpeaker ? Colors.orangeAccent : Colors.grey.shade300,
                child: Text(
                  user['avatar'],
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(height: 6),
              Text(user['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              if (isSpeaker)
                Text(
                  '${user['time']} min',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showUserOptions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final isSpeaker = speakers.contains(user);
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(isSpeaker ? Icons.hearing_disabled : Icons.mic),
                title: Text(isSpeaker ? 'Rendre auditeur' : 'Rendre speaker'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleSpeakerStatus(user);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.redAccent),
                title: const Text('Bloquer cet utilisateur'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(user);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
