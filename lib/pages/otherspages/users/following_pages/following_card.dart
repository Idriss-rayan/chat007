import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FollowingCard extends StatefulWidget {
  final String userName;
  final String country;
  final String city;
  final String userImage;
  final bool isOnline;
  final VoidCallback onUnfollow;

  const FollowingCard({
    super.key,
    required this.userName,
    required this.country,
    required this.city,
    required this.userImage,
    required this.isOnline,
    required this.onUnfollow,
  });

  @override
  State<FollowingCard> createState() => _FollowingCardState();
}

class _FollowingCardState extends State<FollowingCard> {
  bool isFollowing = true;

  void _handleUnfollow() {
    setState(() {
      isFollowing = false;
    });

    // Appel de la fonction parent après l'animation locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onUnfollow();
    });
  }

  void _handleFollowBack() {
    setState(() {
      isFollowing = true;
    });
    // Ici vous pourriez appeler une API pour refollow
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(7, 236, 34, 31),
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(
          //   color: const Color.fromARGB(30, 255, 86, 34),
          // ),
        ),
        child: Row(
          children: [
            // Avatar avec indicateur en ligne
            Stack(
              children: [
                _buildUserAvatar(),
                if (widget.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.userName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(195, 0, 0, 0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(
                        color: Colors.deepOrange.shade200,
                        'assets/component/loc.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.country,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              if (widget.city.isNotEmpty)
                                TextSpan(
                                  text: ' • ${widget.city}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bouton d'action----------------///////////////-------------------------/////////
            //_buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    // Gestion des différents types d'avatar
    if (widget.userImage.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        widget.userImage,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    } else if (widget.userImage.startsWith('http')) {
      // Pour les images réseau
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          widget.userImage,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color.fromARGB(30, 255, 86, 34),
        ),
      ),
      child: Center(
        child: Text(
          widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(195, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  // Widget _buildActionButton() {
  //   if (isFollowing) {
  //     return OutlinedButton(
  //       onPressed: _handleUnfollow,
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: Colors.red,
  //         side: const BorderSide(color: Colors.red),
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //       ),
  //       child: const Text(
  //         'Suivi',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return ElevatedButton(
  //       onPressed: _handleFollowBack,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.orange,
  //         foregroundColor: Colors.white,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //       ),
  //       child: const Text(
  //         'Se desaboner',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     );
  //   }
  // }
}
