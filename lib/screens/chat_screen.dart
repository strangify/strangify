import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/widgets/receive_bubble.dart';
import 'package:strangify/widgets/send_bubble.dart';
import 'package:strangify/widgets/st_text.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/ChatScreen";
  final Map args;
  const ChatScreen({super.key, required this.args});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController chatController = TextEditingController();
  sendMessage(String message) {
    widget.args["chatRef"].update({
      'messageList': FieldValue.arrayUnion([
        {
          'senderId': currentUser!.uid,
          'message': message,
          'time': DateTime.now()
        }
      ])
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    double appbarHeight = AppBar().preferredSize.height;
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StText(widget.args["name"], color: Colors.white),
              const StText("01.10", size: 16, color: Colors.white),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close)),
          ),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.only(
                  top: 22, left: 20, right: 20, bottom: 10),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const StText(
                    "Running low on funds?",
                    weight: FontWeight.w500,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16)),
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: () {},
                      child: const StText(
                        "Recharge",
                        size: 14,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: mq.size.height -
                  appbarHeight -
                  mq.viewInsets.bottom -
                  130 -
                  130,
              child: StreamBuilder(
                  stream: widget.args["chatRef"].snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    List messageList =
                        (snapshot.data!.data() as Map)["messageList"];
                    return ListView.builder(
                      reverse: true,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        messageList.sort((a, b) =>
                            "${b["time"].toDate().millisecondsSinceEpoch}"
                                .compareTo(
                                    "${a["time"].toDate().millisecondsSinceEpoch}"));
                        if (messageList[index]["senderId"] ==
                            currentUser!.uid) {
                          return SendBubble(
                              message: messageList[index]["message"],
                              isLastByUser:
                                  messageList.first != messageList[index],
                              dateTime: messageList[index]["time"].toDate());
                        } else {
                          return ReceiveBubble(
                              message: messageList[index]["message"],
                              isLastByUser:
                                  messageList.first != messageList[index],
                              dateTime: messageList[index]["time"].toDate());
                        }
                      },
                    );
                  }),
            ),
            Container(
              height: 65,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 14, bottom: 9, left: 16, right: 16),
              child: Row(children: [
                Container(
                  width: mq.size.width - 85,
                  margin: const EdgeInsets.only(right: 11),
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: .5, color: const Color(0xFF063763)),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding:
                            const EdgeInsets.only(bottom: (45 - 12) / 2),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Type your message here.',
                        labelStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (chatController.text.isNotEmpty) {
                      sendMessage(chatController.text);
                      chatController.clear();
                    }
                  },
                  child: const CircleAvatar(
                      radius: 21,
                      backgroundColor: primaryColor,
                      child: Padding(
                          padding: EdgeInsets.only(right: 3, top: 2),
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                size: 23,
                                CupertinoIcons.paperplane,
                                color: Colors.white,
                              )))),
                )
              ]),
            )
          ],
        ));
  }
}
