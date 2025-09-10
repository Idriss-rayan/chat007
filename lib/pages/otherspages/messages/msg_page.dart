import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/card_msg.dart';
import 'package:simplechat/pages/otherspages/messages/chat_list.dart';

class MsgPage extends StatefulWidget {
  const MsgPage({super.key});

  @override
  State<MsgPage> createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage> {
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
                Center(
                  child: Text(
                    "group Page",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Stories Page",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Feeds Page",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Calls Page",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
