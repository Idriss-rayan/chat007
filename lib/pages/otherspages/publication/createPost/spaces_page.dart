import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Espace de ${widget.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom : ${widget.name}'),
            Text('Durée : ${widget.duration}'),
            Text('Limite : ${widget.limit}'),
          ],
        ),
      ),
    );
  }
}
