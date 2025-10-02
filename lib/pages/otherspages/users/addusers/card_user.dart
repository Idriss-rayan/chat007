import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardUser extends StatefulWidget {
  final String userName;
  final String country;
  final String countryCode;
  final String userImage;
  final String profession;
  final int mutualFriends;
  final String lastSeen;
  final bool isOnline;
  final bool isInitiallyFollowing;
  final VoidCallback? onFollowChanged;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMessageTap;

  const CardUser({
    super.key,
    required this.userName,
    required this.country,
    this.countryCode = 'cmr',
    this.userImage = 'assets/component/avatar.svg',
    this.profession = 'Développeur',
    this.mutualFriends = 0,
    this.lastSeen = 'En ligne',
    this.isOnline = true,
    this.isInitiallyFollowing = false,
    this.onFollowChanged,
    this.onProfileTap,
    this.onMessageTap,
  });

  @override
  State<CardUser> createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isInitiallyFollowing;
  }

  void _handleFollowTap() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    widget.onFollowChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onProfileTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Première ligne : Avatar et informations principales
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar avec badge en ligne
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade300,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          child: SvgPicture.asset(
                            widget.userImage,
                            width: 66,
                            height: 66,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Badge de statut en ligne
                    if (widget.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Informations utilisateur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et profession
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Profession
                      Text(
                        widget.profession,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Localisation
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/component/loc.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.country,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/component/${widget.countryCode}.svg',
                            width: 14,
                            height: 14,
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Dernière connexion
                      Text(
                        widget.lastSeen,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Deuxième ligne : Amis communs et actions
            Row(
              children: [
                // Amis communs
                if (widget.mutualFriends > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.mutualFriends} ami${widget.mutualFriends > 1 ? 's' : ''} en commun",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ] else
                  const Spacer(),

                // Bouton Message
                // if (_isFollowing) ...[
                //   GestureDetector(
                //     onTap: widget.onMessageTap,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 16,
                //         vertical: 8,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade100,
                //         borderRadius: BorderRadius.circular(20),
                //         border: Border.all(
                //           color: Colors.grey.shade300,
                //         ),
                //       ),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.message,
                //             size: 16,
                //             color: Colors.grey.shade700,
                //           ),
                //           const SizedBox(width: 6),
                //           Text(
                //             'Message',
                //             style: TextStyle(
                //               color: Colors.grey.shade700,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                //   const SizedBox(width: 12),
                // ],

                // Bouton Follow/Unfollow
                GestureDetector(
                  onTap: _handleFollowTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _isFollowing ? Colors.white : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _isFollowing ? Colors.orange : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: _isFollowing
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isFollowing ? Icons.check : Icons.person_add_alt_1,
                          size: 16,
                          color: _isFollowing ? Colors.orange : Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isFollowing ? 'Suivi' : 'Suivre',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isFollowing ? Colors.orange : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
