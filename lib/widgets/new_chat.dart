import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strangify/models/message_model.dart';
import 'package:strangify/widgets/receive_bubble.dart';
import 'package:strangify/widgets/send_bubble.dart';

class NewChat extends StatefulWidget {
  // final DocumentReference chatRef;
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController chatController = TextEditingController();
  // sendMessage(String message) {
  //   widget.chatRef.update({
  //     'messageList': FieldValue.arrayUnion([
  //       {'senderId': user!.uid, 'message': message, 'time': DateTime.now()}
  //     ])
  //   });
  // }

  sendMessage(String message) {
    messageList.add(
        MessageModel(message: message, senderId: "1", time: DateTime.now()));
  }

  List<MessageModel> messageList = [
    MessageModel(
        message: "Hi",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 100))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 50))),
    MessageModel(
        message: "Also, Who are you?",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 150))),
    MessageModel(
        message: "message 4",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 190))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 10))),
    MessageModel(
        message: "message 6",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 40))),
    MessageModel(
        message: "Hi",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 100))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 50))),
    MessageModel(
        message: "Also, Who are you?",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 150))),
    MessageModel(
        message: "message 4",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 190))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 12))),
    MessageModel(
        message: "message 6",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 40))),
    MessageModel(
        message: "Hi",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 100))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 50))),
    MessageModel(
        message: "Also, Who are you?",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 150))),
    MessageModel(
        message: "message 4",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 190))),
    MessageModel(
        message: "Hello, My name is yash, How are you??",
        senderId: "1",
        time: DateTime.now().subtract(const Duration(seconds: 15))),
    MessageModel(
        message: "message 6",
        senderId: "2",
        time: DateTime.now().subtract(const Duration(seconds: 40))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  160 -
                  MediaQuery.of(context).viewInsets.bottom,
              child: ListView.builder(
                reverse: true,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  messageList.sort((a, b) => "${b.time.millisecondsSinceEpoch}"
                      .compareTo("${a.time.millisecondsSinceEpoch}"));
                  if (messageList[index].senderId == "1") {
                    return SendBubble(
                        message: messageList[index].message,
                        isLastByUser: messageList.first != messageList[index],
                        dateTime: messageList[index].time);
                  } else {
                    return ReceiveBubble(
                        message: messageList[index].message,
                        isLastByUser: messageList.first != messageList[index],
                        dateTime: messageList[index].time);
                  }
                },
              ),
            ),
            Container(
              height: 65,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 14, bottom: 9, left: 16, right: 16),
              child: Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width - 85,
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
                      // EasyDebounce.debounce(
                      //     'swap', const Duration(milliseconds: 300), () {
                      //   runMutation({
                      //     "input": {
                      //       "message": {
                      //         "body": chatController.text,
                      //         "conversationId": widget.id,
                      //       },
                      //     }
                      //   });
                      //   chatController.clear();
                      //   //  FocusScope.of(context).unfocus();
                      // });
                      sendMessage(chatController.text);
                      chatController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: const CircleAvatar(
                      child: Padding(
                          padding: EdgeInsets.only(right: 3, top: 1),
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                CupertinoIcons.paperplane,
                                color: Colors.white,
                              ))),
                      radius: 21,
                      backgroundColor: Color(0xFF063763)),
                )
              ]),
            )
          ],
        ));
  }
}
