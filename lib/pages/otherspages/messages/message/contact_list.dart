import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'contact_card.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<dynamic> contacts = [];
  bool isLoading = true;
  final int userId = 1;

  Future<void> fetchContacts() async {
    try {
      final url = Uri.parse('http://192.168.0.169:3000/contacts/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          setState(() {
            contacts = jsonResponse['contacts'];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          print('⚠️ Aucune donnée dans la réponse.');
        }
      } else {
        setState(() => isLoading = false);
        print('❌ Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('⚠️ Erreur réseau: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Liste de contacts",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFFF6B35),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement...',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : contacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contacts_outlined,
                        size: 80,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun contact enregistré',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ajoutez votre premier contact',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ContactCard(contact: contact);
                  },
                ),
    );
  }
}
