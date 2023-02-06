import 'dart:math';

import 'package:flutter/material.dart';
import 'package:strangify/widgets/st_text.dart';

import '../models/user_model.dart';

class HomeBasicTile extends StatelessWidget {
  final User user;
  const HomeBasicTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Hero(
                        tag: "pfp",
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(user.imageUrl!)),
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(40)),
                        ),
                      ),
                    ),
                    user.isOnline!
                        ? const Positioned(
                            bottom: 6,
                            right: 6,
                            child: CircleAvatar(
                                backgroundColor: Colors.green, radius: 9),
                          )
                        : const SizedBox()
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: mq.size.width - 180,
                              child: StText(user.name?.split(" ")[0] ?? "",
                                  weight: FontWeight.w500, size: 16)),
                          Container(
                            // transform:
                            //     Matrix4.translationValues(0, 2, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            child: StText(
                                "${user.gender.toString()[0].toUpperCase()} - ${user.age}Y",
                                weight: FontWeight.bold,
                                size: 10,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(),
                      SizedBox(
                        width: mq.size.width - 130,
                        child: StText(user.description!,
                            maxLines: 2, height: 1, size: 10.5),
                      ),
                      SizedBox(
                          width: mq.size.width - 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber[600],
                                  ),
                                  StText(
                                    " ${(4 + (5 - 4) * Random().nextDouble()).toStringAsFixed(1)}",
                                    weight: FontWeight.w500,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
