import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/messages/calls/list_calls.dart';
import 'package:simplechat/pages/otherspages/messages/message/chat_list.dart';
import 'package:simplechat/pages/otherspages/messages/rooms/list_rooms.dart';
import 'package:simplechat/pages/otherspages/messages/stories/storie_pages.dart';
import 'package:simplechat/pages/otherspages/users/component/search_bar2.dart';

class MsgPage extends StatefulWidget {
  const MsgPage({super.key});

  @override
  State<MsgPage> createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
  bool isSearchActive = false;
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String> _tabs = ["Chat", "Rooms", "Stories", "Feeds", "Calls"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar custom
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6464),
                    Color(0xFFFFB744),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Cercle déco
                  Positioned(
                    right: -60,
                    top: -40,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                            color: const Color.fromARGB(65, 255, 86, 34)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        // Logo papachou.svg
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.horizontal,
                                child: child,
                              ),
                            ),
                            child: isSearchActive
                                ? SearchBar2(
                                    key: const ValueKey("searchbar"),
                                    onClose: () {
                                      setState(() {
                                        isSearchActive = false;
                                      });
                                    },
                                  )
                                : Row(
                                    key: const ValueKey("logoRow"),
                                    children: [
                                      // Logo
                                      SvgPicture.asset(
                                        "assets/logo/PAPAchou.svg",
                                        height: 20,
                                        width: 20,
                                      ),
                                      const Spacer(),
                                      // Icône recherche
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isSearchActive = true;
                                          });
                                        },
                                        icon: const Icon(Icons.search,
                                            color: Colors.black87),
                                      ),
                                      // Icône notifications
                                      PopupMenuButton<int>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        color: Colors.orange.shade50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 6,
                                        onSelected: (value) {
                                          if (value == 1) {
                                            debugPrint(
                                                "Voir les notifications");
                                          } else if (value == 2) {
                                            debugPrint(
                                                "Paramètres des notifications");
                                          } else if (value == 3) {
                                            debugPrint("Tout marquer comme lu");
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.notifications,
                                                  color: Colors.deepOrange,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Voir les notifications",
                                                ),
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
                        ),
                      ],
                    ),
                  ),
                  // Boutons avec underline animée
                  Positioned(
                    bottom: 12,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_tabs.length, (index) {
                        final isActive = _currentPage == index;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                _controller.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.black87
                                      : const Color.fromARGB(255, 207, 51, 4),
                                  fontWeight: isActive
                                      ? FontWeight.normal
                                      : FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            // Barre animée
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: 20,
                              height: 3,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // PageView avec swipe fluide
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                ChatList(),
                ListRooms(),
                StoriePages(),
                Center(
                  child: Text(
                    "Feeds Page",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                ListCalls(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
