import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/users/addusers/list_user.dart';
import 'package:simplechat/pages/otherspages/users/followers_pages/follow_list.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String> _tabs = ["Follow", "Followers", "Friends"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                        SvgPicture.asset(
                          "assets/logo/PAPAchou.svg",
                          height: 20,
                          width: 20,
                        ),

                        const Spacer(),

                        // Search
                        IconButton(
                          onPressed: () {
                            // TODO: ouvrir recherche
                          },
                          icon: const Icon(Icons.search, color: Colors.black87),
                        ),

                        // Notifications
                        IconButton(
                          onPressed: () {
                            // TODO: notifications
                          },
                          icon: const Icon(Icons.notifications,
                              color: Colors.black87),
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
          /////////////-------------------///////////
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                ListUser(),
                FollowList(),
                Center(
                  child: Text('Friends'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
