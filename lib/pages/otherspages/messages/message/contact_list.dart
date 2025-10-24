import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Arrondi seulement en bas
          ),
        ),
        title: Center(
          child: Text("Liste de contacts"),
        ),
      ),
      body: Center(
        child: Text('Aucun contact enregistrer'),
      ),
    );
  }
}
