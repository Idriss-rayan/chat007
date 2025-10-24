import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/messages/calls/page_calls.dart';
import 'package:simplechat/pages/otherspages/messages/message/chat_discussion.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/display_profile.dart';

class CardMsg extends StatefulWidget {
  const CardMsg({super.key});

  @override
  State<CardMsg> createState() => _CardMsgState();
}

class _CardMsgState extends State<CardMsg> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatDiscussion(),
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
          //color: Color.fromARGB(7, 236, 34, 31),
          color: Color.fromARGB(0, 236, 34, 31),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
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
                              tag: "profile",
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
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/bg.png', // chemin de ton image
                                        width: 250,
                                        height: 200,
                                        fit: BoxFit
                                            .fill, // pour que l'image remplisse le cadre correctement
                                      ),
                                      Spacer(),
                                      Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
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
                                                          const ChatDiscussion(),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        return SlideTransition(
                                                          position:
                                                              Tween<Offset>(
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
                                                icon: Icon(Icons.message),
                                              ),
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
                                                          position:
                                                              Tween<Offset>(
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
                                                icon: Icon(Icons.call),
                                              ),
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
                                                            'idriss rayan',
                                                        phoneNumber:
                                                            '+237 690545256',
                                                      ),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        return SlideTransition(
                                                          position:
                                                              Tween<Offset>(
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
                                                icon: Icon(Icons.info),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
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
                tag: "profile",
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(195, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
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
