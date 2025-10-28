import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/messages/calls/page_calls.dart';
import 'package:simplechat/pages/otherspages/messages/message/chat_discussion.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/display_profile.dart';

class CardMsg extends StatefulWidget {
  final int userId;
  final int contactId;
  final String contactName;

  const CardMsg({
    super.key,
    required this.userId,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<CardMsg> createState() => _CardMsgState();
}

class _CardMsgState extends State<CardMsg> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ Ouvre la page de discussion
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ChatDiscussion(
              userId: widget.userId,
              contactId: widget.contactId,
              contactName: widget.contactName,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 236, 34, 31),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ✅ Avatar avec Hero + menu profil
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Hero(
                              tag: "profile_${widget.contactId}",
                              child: Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        'assets/images/bg.png',
                                        width: 250,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.deepOrange,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // 🟠 Bouton message
                                            IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDiscussion(
                                                      userId: widget.userId,
                                                      contactId:
                                                          widget.contactId,
                                                      contactName:
                                                          widget.contactName,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.message),
                                            ),

                                            // 🟢 Bouton appel
                                            IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        const PageCalls(
                                                      name: 'rayan',
                                                    ),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              0.0, 0.2),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.call),
                                            ),

                                            // 🔵 Bouton profil
                                            IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        DisplayProfile(
                                                      userName:
                                                          widget.contactName,
                                                      phoneNumber:
                                                          '+237 690545256',
                                                    ),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              0.0, 0.2),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.info),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: "profile_${widget.contactId}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SvgPicture.asset(
                    'assets/component/avatar.svg',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ✅ Infos de contact
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(195, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Dernier message...",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const Text(
              "12:45",
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
