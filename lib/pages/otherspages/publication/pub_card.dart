import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:simplechat/pages/otherspages/publication/comment_card.dart';

class PubCard extends StatefulWidget {
  const PubCard({super.key});

  @override
  State<PubCard> createState() => _PubCardState();
}

class _PubCardState extends State<PubCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?img=8"), // fake avatar
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        'Njutapmvoui Idriss rayan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '2M views . 10 years ago',
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '''L’esclave qui n’est pas capable d’assumer sa révolte ne mérite pas que l’on s’apitoie sur son sort. Voir plus''',
              ),
            ),
            Container(
              width: double.infinity,
              height: height * 0.4,
              decoration: BoxDecoration(
                //color: Colors.amber,
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.deepOrange],
                ),
                //border: Border.all(color: Colors.black),
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: height * 0.07,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LikeButton(
                          size: 30,
                          likeCount: 99,
                          countBuilder: (count, isLiked, text) {
                            return Text(
                              text,
                              style: TextStyle(
                                color: isLiked ? Colors.pink : Colors.grey,
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.8,
                                  minChildSize: 0.4,
                                  maxChildSize: 0.95,
                                  builder: (context, scrollController) {
                                    return Column(
                                      children: [
                                        // 🔹 Liste des commentaires
                                        Expanded(
                                          child: ListView(
                                            controller: scrollController,
                                            padding: const EdgeInsets.all(12),
                                            children: const [
                                              CommentCard(
                                                username: "Rayan Idriss",
                                                comment:
                                                    "Super citation, ça m’inspire beaucoup !",
                                                timeAgo: "il y a 2h",
                                                avatarUrl:
                                                    "https://i.pravatar.cc/150?img=10",
                                              ),
                                              CommentCard(
                                                username: "Fatima",
                                                comment:
                                                    "Merci d’avoir partagé, très puissant 👌",
                                                timeAgo: "il y a 30min",
                                                avatarUrl:
                                                    "https://i.pravatar.cc/150?img=12",
                                              ),
                                              CommentCard(
                                                username: "Ali",
                                                comment:
                                                    "Magnifique, je vais le partager ✨",
                                                timeAgo: "il y a 5min",
                                                avatarUrl:
                                                    "https://i.pravatar.cc/150?img=15",
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 🔹 Zone d’écriture
                                        SafeArea(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors
                                                          .grey.shade300)),
                                            ),
                                            child: Row(
                                              children: [
                                                const CircleAvatar(
                                                    radius: 18,
                                                    child: Icon(Icons.person)),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Écrire un commentaire...",
                                                      border: InputBorder.none,
                                                    ),
                                                    onSubmitted: (value) {
                                                      // TODO: ajouter le commentaire dynamiquement
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.send,
                                                      color: Colors.pink),
                                                  onPressed: () {
                                                    // TODO: ajouter le commentaire dynamiquement
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SvgPicture.asset(
                                  'assets/component/msg.svg',
                                  width: 30,
                                  height: 30,
                                  color: Colors.pink,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '1027 comments',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SvgPicture.asset(
                                  'assets/component/Share.svg',
                                  width: 30,
                                  height: 30,
                                  color: Colors.pink,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '107 repost',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
