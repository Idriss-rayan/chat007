import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

class PublicationCard extends StatelessWidget {
  const PublicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "L’esclave qui n’est pas capable ur son sort.",
                ),
              ),
              Container(
                width: double.infinity,
                height: height * 0.4,
                decoration: BoxDecoration(
                  //color: Colors.amber,
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.deepOrange],
                  ),
                  //border: Border.all(color: Colors.black),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.07,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LikeButton(
                            size: 30,
                            likeCount: 123,
                            countBuilder: (count, isLiked, text) {
                              return Text(
                                text,
                                style: TextStyle(
                                  color: isLiked ? Colors.pink : Colors.grey,
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              'assets/component/msg.svg',
                              width: 30,
                              height: 30,
                              color: Colors.pink,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              'assets/component/Share.svg',
                              width: 30,
                              height: 30,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=8"), // fake avatar
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              'Citation : la plus grande et l’une des meilleure!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'I.Rayan . 2M views . 10 years ago',
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
