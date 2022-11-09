import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/models/user_model.dart';
import 'package:strangify/screens/call_screen.dart';
import 'package:strangify/screens/chat_screen.dart';

import '../widgets/st_text.dart';

class ListenerDetailScreen extends StatefulWidget {
  final User user;
  static const routeName = "/ListenerDetailScreen";
  const ListenerDetailScreen({super.key, required this.user});

  @override
  State<ListenerDetailScreen> createState() => _ListenerDetailScreenState();
}

class _ListenerDetailScreenState extends State<ListenerDetailScreen> {
  Container customContainer(String text, [String? subtext]) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 6,
                color: Color.fromRGBO(0, 0, 0, .14))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StText(
            text,
            maxLines: 1,
            weight: FontWeight.w500,
          ),
          if (subtext != null)
            StText(subtext,
                maxLines: 3,
                // overflow: TextOverflow.ellipsis,
                align: TextAlign.center,
                //style: TextStyle(
                size: 12,
                color: const Color(0xFF707070)),
        ],
      ),
    );
  }

  DocumentReference? chatRef;
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        //color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const StText(
                      "Details",
                      height: 1,
                      size: 18,
                      //   weight: FontWeight.w500,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 116,
            child: ListView(
              padding: EdgeInsets.only(left: 16, right: 16),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Hero(
                            tag: "pfp",
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(widget.user.imageUrl!)),
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: mq.size.width - 160,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StText(
                                        widget.user.name!.split(" ")[0],
                                        size: 24,
                                        weight: FontWeight.w400,
                                      ),
                                      StText(
                                        widget.user.isOnline!
                                            ? "ONLINE"
                                            : "OFFLINE",
                                        size: 12,
                                        weight: FontWeight.w500,
                                        color: widget.user.isOnline!
                                            ? Colors.green
                                            : Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Colors.amber[600],
                                    ),
                                    StText(
                                      " -",
                                      weight: FontWeight.w500,
                                      size: 14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  transform: Matrix4.translationValues(0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  child: StText(
                                    "${widget.user.gender.toString()[0].toUpperCase()} - ${widget.user.age}Y",
                                    weight: FontWeight.bold,
                                    size: 13,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ]),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StText("My Story",
                          size: 20,
                          color: primaryColor,
                          weight: FontWeight.w500),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: StText(
                            widget.user.description.toString(),
                            size: 14,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 8),
                        child: StText("Interests",
                            size: 20,
                            color: primaryColor,
                            weight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 125,
                          child: ListView.builder(
                            itemCount: widget.user.tags?.length ?? 0,
                            itemBuilder: (context, index) {
                              return customContainer(
                                  interestList[interestList.indexWhere(
                                      (element) =>
                                          element["name"].toLowerCase() ==
                                          widget.user.tags![index])]["name"],
                                  interestList[0]["desc"]);
                            },
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 4, bottom: 15),
                            scrollDirection: Axis.horizontal,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 8),
                        child: StText("Languages",
                            size: 20,
                            color: primaryColor,
                            weight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: widget.user.languages?.length ?? 0,
                            itemBuilder: (context, index) {
                              return customContainer(
                                  widget.user.languages![index]);
                            },
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 4, bottom: 15),
                            scrollDirection: Axis.horizontal,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 8),
                        child: StText("Reviews",
                            size: 20,
                            color: primaryColor,
                            weight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: widget.user.reviews?.length ?? 0,
                            itemBuilder: (context, index) {
                              return customContainer(
                                  widget.user.languages![index]);
                            },
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 4, bottom: 15),
                            scrollDirection: Axis.horizontal,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Platform.isIOS ? 60 : 50,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: Platform.isIOS ? 60 : 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(112, 112, 112, 1),
                        width: .3),
                    color: Colors.white,
                  ),
                  child: TextButton(
                      onPressed: () async {
                        chatRef = FirebaseFirestore.instance
                            .collection('messages')
                            .doc();
                        chatRef!.set({
                          "speakerId": currentUser!.uid,
                          "listenerId": widget.user.uid,
                          "time": DateTime.now(),
                          "messageList": [],
                          "status": "waiting"
                        });
                        Navigator.of(context)
                            .pushNamed(ChatScreen.routeName, arguments: {
                          "name": widget.user.name,
                          "speakerId": currentUser!.uid,
                          "listenerId": widget.user.uid,
                          "chatRef": chatRef
                        }); // arguments: {
                        //   'id': widget.id,
                        //   'mainList': widget.mainList,
                        //   'title': widget.title,
                        //   'price': widget.price,
                        //   'experienceDetail': widget.experienceDetail,
                        //   'locations': widget.locations,
                        //   'host': widget.host,
                        //   'timeSlot': widget.timeSlot,
                        //   'isSelfHosted': widget.isSelfHosted,
                        // });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.chat_bubble_2),
                          SizedBox(
                            width: 8,
                          ),
                          const Text('Chat', style: TextStyle(fontSize: 16)),
                        ],
                      )),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: Platform.isIOS ? 60 : 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(112, 112, 112, 1),
                        width: .3),
                    color: primaryColor,
                  ),
                  child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed(CallScreen.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.phone, color: Colors.white),
                          SizedBox(
                            width: 8,
                          ),
                          const StText('Call', size: 16, color: Colors.white),
                        ],
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
