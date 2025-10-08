import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:simplechat/model/provider_model.dart';
import 'package:simplechat/pages/otherspages/publication/component/search_bar.dart';
import 'package:simplechat/pages/otherspages/publication/createPost/create_post_main_page.dart';
import 'package:simplechat/pages/otherspages/publication/pub_card.dart';
import 'package:simplechat/pages/otherspages/publication/spaces/spaces.dart';
// ton modèle Post

class PubPage extends StatefulWidget {
  const PubPage({super.key});

  @override
  State<PubPage> createState() => _PubPageState();
}

class _PubPageState extends State<PubPage> {
  bool isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    // ✅ récupère la liste de posts depuis le provider
    final postProvider = Provider.of<PostProvider>(context);
    final posts = postProvider.posts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 HEADER (Logo + Search/Notifs)
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: SvgPicture.asset(
                        "assets/logo/PAPAchou.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: isSearchActive
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SearchBarCostum(
                              onClose: () {
                                setState(() {
                                  isSearchActive = false;
                                });
                              },
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/component/addPub1.svg",
                                  width: 28,
                                  height: 28,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const CreatePostMainPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/component/search.svg",
                                  width: 28,
                                  height: 28,
                                  color: Colors.deepOrangeAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSearchActive = true;
                                  });
                                },
                              ),
                              PopupMenuButton<int>(
                                icon: Icon(Icons.more_vert,
                                    color: Colors.deepOrange),
                                color: Colors.orange.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 6,
                                onSelected: (value) {
                                  if (value == 1)
                                    debugPrint("Voir les notifications");
                                  if (value == 2)
                                    debugPrint("Paramètres des notifications");
                                  if (value == 3)
                                    debugPrint("Tout marquer comme lu");
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.notifications,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Voir les notifications"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        Icon(Icons.settings,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Paramètres"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        Icon(Icons.done_all,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Tout marquer comme lu"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxHeight: 500,
                              minHeight: 200,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Public Discussion",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    itemCount: 900,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                      ;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Spaces(),
                  );
                },
              ),
            ),

            // 🔹 LISTE PRINCIPALE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PubCard(
                      text: post.text,
                      imageFile: post.image,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
