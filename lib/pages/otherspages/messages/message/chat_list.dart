import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/message/contact_list.dart';
import 'card_msg.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        itemCount: 0,
        itemBuilder: (context, index) {
          return const CardMsg();
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        shape: CircleBorder(
            // side: BorderSide(
            //   color: Colors.deepOrange, // Couleur de la bordure
            //   width: 1.0, // Épaisseur de la bordure
            // ),
            ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactList(),
            ),
          );
        },

        backgroundColor: Colors.orange, // Couleur personnalisée
        child: const Icon(
          Icons.add,
          color: Colors.deepOrange,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Position
    );
  }
}
