import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/helpers/methods.dart';
import 'package:strangify/models/user_model.dart';
import 'package:strangify/screens/call_screen.dart';
import 'package:strangify/screens/chat_screen.dart';
import 'package:strangify/widgets/connecting_sheet.dart';

import '../helpers/triangle_clipper.dart';
import '../providers/settings_provider.dart';
import '../widgets/st_header.dart';
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

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    setState(() {
      chatRef = FirebaseFirestore.instance.collection('session').doc();
      chatStream = chatRef!.snapshots().listen((event) {
        if (event.data() != null) {
          if ((event.data() as Map).containsKey("status")) {
            if ((event.data() as Map)["status"] == "waiting") {
              setState(() {
                showSheet = true;
              });
            } else if ((event.data() as Map)["status"] == "active") {
              if ((event.data() as Map)["type"] == "call") {
                chatStream!.cancel();
                setState(() {
                  showSheet = false;
                });
                Navigator.of(context)
                    .pushReplacementNamed(CallScreen.routeName, arguments: {
                  "listenerName": widget.user.name,
                  "speakerName": "Anonymous",
                  "chatRef": chatRef,
                  "speakerId": currentUser!.uid,
                  "listenerId": widget.user.uid,
                  "role": widget.user.role
                });
              } else {
                chatStream!.cancel();
                setState(() {
                  showSheet = false;
                });

                Navigator.of(context)
                    .pushReplacementNamed(ChatScreen.routeName, arguments: {
                  "listenerName": widget.user.name,
                  "speakerName": "Anonymous",
                  "speakerId": currentUser!.uid,
                  "listenerId": widget.user.uid,
                  "chatRef": chatRef,
                  "role": widget.user.role
                });
              }
            } else {
              setState(() {
                showSheet = false;
              });
              showSnack(
                  margin: 50,
                  color: Colors.red,
                  context: context,
                  message:
                      "Request has been ${(event.data() as Map)["status"].toString().capitalize()}");
            }
          }
        }
      });
    });
  }

  bool showSheet = false;
  StreamSubscription? chatStream;
  DocumentReference? chatRef;
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingProvider = Provider.of<SettingsProvider>(context);
    final MediaQueryData mq = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 90),
        child: StHeader(
            child2: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 22, color: Colors.white),
            ),
            child1: const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: StText("Details",
                    size: 20, color: Colors.white, weight: FontWeight.w600),
              ),
            )),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: ListView(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  children: [
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Hero(
                              tag: "pfp",
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            widget.user.imageUrl!)),
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          )),
                    ),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StText(widget.user.name!.split(" ")[0],
                              size: 24,
                              color: primaryColor,
                              weight: FontWeight.w600),

                          // const SizedBox(height: 3),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              //   border: Border.all(color: primaryColor),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            child: StText(
                                "${widget.user.gender.toString()[0].toUpperCase()} - ${widget.user.age}y",
                                weight: FontWeight.bold,
                                size: 12,
                                color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                        ]),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          border: Border.all(color: primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: StText(
                                    widget.user.role == "listener"
                                        ? "My Story"
                                        : "Bio",
                                    size: 18,
                                    color: primaryColor,
                                    weight: FontWeight.w400),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 8, right: 8),
                                  child: StText(
                                      widget.user.description.toString(),
                                      size: 13,
                                      align: TextAlign.center)),
                            ],
                          ),
                        )),
                    // ClipPath(
                    //   clipper: TriangleClipper(),
                    //   child: Container(
                    //     height: 60,
                    //     color: primaryColor,
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 60),
                          StText(
                            "${widget.user.role == "listener" ? settingProvider.getSettings!.listenerCharge : settingProvider.getSettings!.counsellorCharge}.00 Rs ",
                            color: Colors.white,
                            weight: FontWeight.w500,
                          ),
                          const StText(
                            "per min",
                            size: 14,
                            color: Colors.white,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 8),
                            child: StText(
                                widget.user.role == "listener"
                                    ? "Interests"
                                    : "Specialization",
                                size: 20,
                                color: primaryColor,
                                weight: FontWeight.w500),
                          ),
                          SizedBox(
                              height: 125,
                              child: ListView.builder(
                                itemCount: widget.user.tags?.length ?? 0,
                                itemBuilder: (context, index) {
                                  int i = interestList.indexWhere((element) =>
                                      element["name"].toLowerCase() ==
                                      widget.user.tags![index].toLowerCase());
                                  return customContainer(
                                      interestList[i]["name"],
                                      interestList[i]["desc"]);
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
                          const Padding(
                            padding: EdgeInsets.only(top: 2, bottom: 8),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 2, bottom: 8),
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
                  ]),
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
                          chatRef!.set({
                            "speakerId": currentUser!.uid,
                            "listenerId": widget.user.uid,
                            "time": DateTime.now(),
                            "messageList": [],
                            "status": "waiting",
                            'type': 'chat',
                            "listenerName": widget.user.name,
                            "speakerName": "Anonymous",
                          });
                          // Navigator.of(context)
                          //     .pushNamed(ChatScreen.routeName, arguments: {
                          //   "name": widget.user.name,
                          //   "speakerId": currentUser!.uid,
                          //   "listenerId": widget.user.uid,
                          //   "chatRef": chatRef
                          // }); // arguments: {
                          // //   'id': widget.id,
                          // //   'mainList': widget.mainList,
                          // //   'title': widget.title,
                          // //   'price': widget.price,
                          // //   'experienceDetail': widget.experienceDetail,
                          // //   'locations': widget.locations,
                          // //   'host': widget.host,
                          // //   'timeSlot': widget.timeSlot,
                          // //   'isSelfHosted': widget.isSelfHosted,
                          // // });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.chat_bubble_2),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Chat', style: TextStyle(fontSize: 16)),
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
                          //TODO as condition for <35

                          chatRef!.set({
                            "speakerId": currentUser!.uid,
                            "listenerId": widget.user.uid,
                            "time": DateTime.now(),
                            "status": "waiting",
                            'type': 'call',
                            "listenerName": widget.user.name,
                            "speakerName": "Anonymous",
                          });

                          // Navigator.of(context).pushNamed(CallScreen.routeName,
                          //     arguments: {
                          //       "name": widget.user.name,
                          //       "chatRef": chatRef
                          //     });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.phone, color: Colors.white),
                            SizedBox(
                              width: 8,
                            ),
                            StText('Call', size: 16, color: Colors.white),
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ),
        showSheet ? ConnectingSheet(chatRef: chatRef!) : const SizedBox()
      ]),
    );
  }
}
