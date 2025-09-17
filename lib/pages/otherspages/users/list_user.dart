import 'package:flutter/material.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';
import 'package:simplechat/pages/otherspages/users/card_user.dart';
import 'package:simplechat/pages/otherspages/users/card_user2.dart';

class ListUser extends StatelessWidget {
  const ListUser({super.key});

  @override
  Widget build(BuildContext context) {
    // Nombre total de CardUser2
    const int totalCardUser2 = 1000;
    // Chaque bloc contient 10 CardUser2
    const int cardUser2PerRow = 10;
    // Nombre total de blocs horizontaux
    final int totalHorizontalBlocks = (totalCardUser2 / cardUser2PerRow).ceil();

    // Chaque bloc horizontal est précédé par 9 CardUser
    final int totalItems = totalHorizontalBlocks * (9 + 1);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // Tous les 10ème item (après 9 CardUser) -> bloc horizontal
        if ((index + 1) % 10 == 0) {
          // Bloc horizontal actuel (0, 1, 2, ...)
          final int blockIndex = (index + 1) ~/ 10 - 1;

          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cardUser2PerRow,
              itemBuilder: (context, i) {
                // Calculer l’index global de CardUser2
                final int cardUser2Index = blockIndex * cardUser2PerRow + i;

                if (cardUser2Index >= totalCardUser2) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CardUser2(), // ici tu peux aussi passer l’index
                );
              },
            ),
          );
        }

        // Sinon -> CardUser normal
        return CardUser();
      },
    );
  }
}
