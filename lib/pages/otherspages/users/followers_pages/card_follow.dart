import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class CardFollow extends StatefulWidget {
  final String userName;
  final String country;
  final String userImage;
  final int currentUserId;
  final int targetUserId;
  final bool isOnline;
  final VoidCallback onUnfollow;

  const CardFollow({
    super.key,
    required this.userName,
    required this.country,
    this.userImage = 'assets/component/avatar.svg',
    this.isOnline = true,
    required this.onUnfollow,
    required this.currentUserId,
    required this.targetUserId,
  });

  @override
  State<CardFollow> createState() => _CardFollowState();
}

class _CardFollowState extends State<CardFollow>
    with SingleTickerProviderStateMixin {
  bool isFollowed = false;
  static const String baseUrl = 'http://192.168.0.169:3000';
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

    _checkContactStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleFollow() {
    if (isFollowed) {
      _showAddContactDialog();
    } else {
      _showUnfollowDialog();
    }
  }

  //////////////////////////--------------------////////////////////
  void _checkContactStatus() async {
    bool exists = await isContact(
      widget.currentUserId,
      widget.targetUserId,
    );
    setState(() {
      isFollowed = exists;
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
                                      color: const Color.fromARGB(
                                          55, 64, 195, 255),
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        'Contact',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
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

  void _showUnfollowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFFFF5F5),
                  Color(0xFFFFF0F0),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFFFB6C1).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFFB6C1).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.person_add_alt_1,
                      color: Color(0xFFFF6B95),
                      size: 30,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Title
                  Text(
                    "Add to your contact list",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12),

                  // Content
                  Text(
                    "By continuing this action, you will add this user to your contact list, and you'll then be able to start a conversation with them.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFFFB6C1).withOpacity(0.5),
                              width: 1,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFFFFAFA),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFFFF6B95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Confirm Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF6B95),
                                Color(0xFFFF8E53),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B95).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              bool success = await addContact(
                                widget.currentUserId,
                                widget.targetUserId,
                              );

                              if (success) {
                                setState(() {
                                  isFollowed = true;
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
          ),
        );
      },
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFFFF9F2),
                  Color(0xFFFFF5ED),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFFFB74D).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF5E6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFFB74D).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFF9800),
                      size: 30,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Title
                  Text(
                    "Remove from contacts?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12),

                  // Content
                  Text(
                    "Are you sure you want to remove this user from your contact list? You'll no longer be able to start conversations with them.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFFFB74D).withOpacity(0.5),
                              width: 1,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFFFFBF6),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFFFF9800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Keep Contact",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Remove Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF9800),
                                Color(0xFFFF5722),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF9800).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () async {
                              bool success = await removeContact(
                                widget.currentUserId,
                                widget.targetUserId,
                              );

                              if (success) {
                                setState(() {
                                  isFollowed = false;
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
          ),
        );
      },
    );
  }

  // Ajouter un contact
  static Future<bool> addContact(int userId, int contactId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'contact_id': contactId,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Supprimer un contact
  static Future<bool> removeContact(int userId, int contactId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'contact_id': contactId,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Vérifier si contact existe
  static Future<bool> isContact(int userId, int contactId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/contacts/check?user_id=$userId&contact_id=$contactId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
