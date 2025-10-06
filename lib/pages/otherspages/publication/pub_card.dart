import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:simplechat/pages/otherspages/publication/comment_card.dart';
import 'package:simplechat/pages/otherspages/publication/comment_field.dart';
import 'package:simplechat/pages/otherspages/publication/component/recent.dart';
import 'package:simplechat/pages/otherspages/publication/component/recent_white.dart';
import 'package:simplechat/pages/otherspages/publication/component/top.dart';
import 'package:simplechat/pages/otherspages/publication/component/top_white.dart';

class PubCard extends StatefulWidget {
  final String text;
  final File? imageFile;
  const PubCard({super.key, required this.text, required this.imageFile});

  @override
  State<PubCard> createState() => _PubCardState();
}

class _PubCardState extends State<PubCard> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Material(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          NetworkImage("https://i.pravatar.cc/150?img=8"),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Njutapmvoui Idriss rayan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '2M views . 10 years ago',
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.text),
              ),

              // Image / Video placeholder
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.deepOrange],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Image.file(
                        widget.imageFile ?? File('assets/images/default.jpg'),
                        height: height * 0.25,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              // Buttons (Like, Comment, Share)
              Container(
                width: double.infinity,
                height: height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Like button
                      LikeButton(
                        size: 30,
                        likeCount: 99,
                        countBuilder: (count, isLiked, text) {
                          return Text(
                            text,
                            style: TextStyle(
                              color: isLiked ? Colors.pink : Colors.grey,
                            ),
                          );
                        },
                      ),

                      // Comment button
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            builder: (context) {
                              int localSelectedTab = selectedTab;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.5,
                                      minChildSize: 0.3,
                                      maxChildSize: 0.8,
                                      builder: (context, scrollController) {
                                        return Column(
                                          children: [
                                            SizedBox(height: 25),
                                            Container(
                                              width: 50,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    157, 158, 158, 158),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Comment',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            // Tabs
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 100),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        localSelectedTab = 0;
                                                      });
                                                    },
                                                    child: localSelectedTab == 1
                                                        ? TopWhite()
                                                        : Top(),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        localSelectedTab = 1;
                                                      });
                                                    },
                                                    child: localSelectedTab == 1
                                                        ? RecentWhite()
                                                        : Recent(),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Comments list
                                            Expanded(
                                              child: ListView.builder(
                                                controller: scrollController,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                itemCount: 6,
                                                itemBuilder: (context, index) {
                                                  return const CommentCard(
                                                    username: "Ali",
                                                    comment:
                                                        "Magnifique, je vais le partager ✨",
                                                    timeAgo: "il y a 5min",
                                                    avatarUrl:
                                                        "https://i.pravatar.cc/150?img=12",
                                                  );
                                                },
                                              ),
                                            ),

                                            // Comment input
                                            SafeArea(
                                              child: CommentField(),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SvgPicture.asset(
                                'assets/component/msg.svg',
                                width: 30,
                                height: 30,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '1027 comments',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),

                      // Share button
                      InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SvgPicture.asset(
                                'assets/component/Share.svg',
                                width: 30,
                                height: 30,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '107 repost',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
