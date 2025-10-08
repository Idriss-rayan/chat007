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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(
                                maxHeight: 650, minHeight: 400),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Petit indicateur pour drag
                                Center(
                                  child: Container(
                                    width: 45,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                const Center(
                                  child: Text(
                                    "Environnement politique au cameroun",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // --- Section Speakers ---
                                const Text(
                                  "Speakers",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // GridView pour les Speakers
                                SizedBox(
                                  height:
                                      160, // hauteur fixe pour garder un layout stable
                                  child: GridView.builder(
                                    // shrinkWrap: true,
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        12, // par ex : nombre de speakers
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // 4 par ligne
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.deepOrange,
                                                width: 0.5,
                                              ),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/rayan.png"),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.deepOrange
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Speaker ${index + 1}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // --- Section Listeners ---
                                const Text(
                                  "Listeners",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // GridView extensible pour les listeners
                                Expanded(
                                  child: GridView.builder(
                                    itemCount: 30,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.85,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade200,
                                              border: Border.all(
                                                  color: Colors.grey.shade400),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/bg.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "User ${index + 1}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      );
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
