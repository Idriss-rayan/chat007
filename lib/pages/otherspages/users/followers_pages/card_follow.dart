import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardFollow extends StatefulWidget {
  final String userName;
  final String country;
  final String userImage;

  final bool isOnline;
  final VoidCallback onUnfollow;

  const CardFollow({
    super.key,
    required this.userName,
    required this.country,
    this.userImage = 'assets/component/avatar.svg',
    this.isOnline = true,
    required this.onUnfollow,
  });

  @override
  State<CardFollow> createState() => _CardFollowState();
}

class _CardFollowState extends State<CardFollow>
    with SingleTickerProviderStateMixin {
  bool isFollowed = true; // Toujours true car c'est un follower

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleFollow() {
    setState(() {
      isFollowed = !isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.pink.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.orange.shade200),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar avec badge online
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ClipOval(
                      child: widget.userImage.startsWith('http')
                          ? Image.network(
                              widget.userImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return SvgPicture.asset(
                                  'assets/component/avatar.svg',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : SvgPicture.asset(
                              widget.userImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                // Badge online
                if (widget.isOnline)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Follow Button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.userName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: toggleFollow,
                      //   child: ScaleTransition(
                      //     scale: _scaleAnimation,
                      //     child: Container(
                      //       padding: EdgeInsets.all(6),
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.transparent,
                      //       ),
                      //       child: SvgPicture.asset(
                      //         isFollowed
                      //             ? 'assets/component/contact.svg'
                      //             : 'assets/component/friends 1.svg',
                      //         width: 28,
                      //         height: 28,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Location
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/component/loc.svg',
                        width: 18,
                        height: 15,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        widget.country,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: toggleFollow,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: isFollowed
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.deepOrange,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Add as contact'),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(
                                        7,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Contact now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
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
    );
  }
}
