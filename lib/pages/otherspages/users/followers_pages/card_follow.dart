import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardFollow extends StatefulWidget {
  const CardFollow({super.key});

  @override
  State<CardFollow> createState() => _CardFollowState();
}

class _CardFollowState extends State<CardFollow>
    with SingleTickerProviderStateMixin {
  bool isFollowed = false;

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
      if (isFollowed) {
        _controller.forward().then((value) => _controller.reverse());
      } else {
        _controller.forward().then((value) => _controller.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipOval(
                  child: SvgPicture.asset(
                    'assets/component/avatar.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                          "Idriss Rayan".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleFollow,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFollowed
                                  ? Colors.transparent
                                  : Colors.transparent,
                            ),
                            child: SvgPicture.asset(
                              isFollowed
                                  ? 'assets/component/contact.svg'
                                  : 'assets/component/friends 1.svg',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Location
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/component/loc.svg',
                        width: 18,
                        height: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Cameroun",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        'assets/component/cmr.svg',
                        width: 12,
                        height: 12,
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
