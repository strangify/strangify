import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/services/session_service.dart';
import 'package:strangify/services/user_services.dart';
import 'package:strangify/widgets/delete_confirm.dart';
import 'package:strangify/widgets/receive_bubble.dart';
import 'package:strangify/widgets/send_bubble.dart';
import 'package:strangify/widgets/st_text.dart';

import '../providers/settings_provider.dart';
import '../widgets/st_header.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/ChatScreen";
  final Map args;
  const ChatScreen({super.key, required this.args});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  Timer? timer;
  // DateTime currentTime = DateTime.parse(
  //     DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now().toLocal()));
  StreamSubscription<int>? timerSubscription;
  bool timerCancel = true;
  bool shouldPause = false;
  String hoursStr = "00";
  String minutesStr = "00";
  String secondsStr = "00";
  SettingsProvider? settingsP;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    var timerStream = stopWatchStream();
    settingsP = Provider.of<SettingsProvider>(context, listen: false);
    timerSubscription = timerStream.listen((int newTick) {
      if (mounted) {
        setState(() {
          hoursStr =
              ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    hoursStr = "";
    minutesStr = "";
    secondsStr = "";
    timer!.cancel();
    timerSubscription!.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused &&
        widget.args["listenerId"] == currentUser!.uid) {
      SessionService().updateSession({
        "id": widget.args["chatRef"].id,
        "shouldPause": true,
      });
      timerSubscription!.pause();
    } else if (state == AppLifecycleState.resumed &&
        widget.args["listenerId"] == currentUser!.uid) {
      print("Ca;;ed");
      SessionService().updateSession({
        "id": widget.args["chatRef"].id,
        "shouldPause": false,
      });
      timerSubscription!.resume();
    }
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      endSessionDialog(context, "Chat", () async {
        SessionService().updateSession({
          "id": widget.args["chatRef"].id,
          "status": "ended",
          "totalTime": "$hoursStr:$minutesStr:$secondsStr",
          "listenerAmount": ((int.parse(hoursStr) * 60) +
                  int.parse(minutesStr) +
                  (int.parse(secondsStr) > 14 ? 1 : 0)) *
              (widget.args["role"] == "listener"
                  ? settingsP!.settings!.listenerPay
                  : settingsP!.settings!.counsellorPay),
          "userAmount": ((int.parse(hoursStr) * 60) +
                  int.parse(minutesStr) +
                  (int.parse(secondsStr) > 14 ? 1 : 0)) *
              (widget.args["role"] == "listener"
                  ? settingsP!.settings!.listenerCharge
                  : settingsP!.settings!.counsellorCharge)
        });

        worksheet!.values.rowByKey(widget.args["listenerId"]).then((value) {
          print(value);
          if (value != null) {
            double amount = double.parse(value.last.toString());
            worksheet!.values
                .insertRowByKey(
                    widget.args["listenerId"],
                    [
                      amount +
                          ((int.parse(hoursStr) * 60) +
                                  int.parse(minutesStr) +
                                  (int.parse(secondsStr) > 14 ? 1 : 0)) *
                              (widget.args["role"] == "listener"
                                  ? settingsP!.settings!.listenerPay
                                  : settingsP!.settings!.counsellorPay)
                    ],
                    fromColumn: value.length + 1)
                .then((value) => print(value));
          }
        });
      });
    }
  }

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      if (!shouldPause) {
        counter++;
        streamController!.add(counter);
        if (counter % 15 == 0 &&
            counter % 60 != 0 &&
            counter % 30 != 0 &&
            counter % 45 != 0) {
          if (widget.args["speakerId"] == currentUser!.uid) {
            print("called");
            FirebaseFirestore.instance
                .collection("users")
                .doc(widget.args["listenerId"])
                .update({
              "walletBalance": FieldValue.increment(
                  (widget.args["role"] == "listener"
                      ? settingsP!.settings!.listenerPay
                      : settingsP!.settings!.counsellorPay))
            });
            FirebaseFirestore.instance
                .collection("users")
                .doc(widget.args["speakerId"])
                .update({
              "walletBalance": FieldValue.increment(
                  -(widget.args["role"] == "listener"
                      ? settingsP!.settings!.listenerCharge
                      : settingsP!.settings!.counsellorCharge))
            });
          }
        }
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      //onResume: startTimer,
      //onPause: () {},
    );

    return streamController.stream;
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
    UserProvider userP = Provider.of<UserProvider>(context);

    double appbarHeight = AppBar().preferredSize.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 90),
            child: StHeader(
                hideWallet: true,
                child2: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () async {
                      //   Navigator.of(context).pop();
                      endSessionDialog(context, "Chat", () async {
                        worksheet!.values
                            .rowByKey(widget.args["listenerId"])
                            .then((value) {
                          print(value);
                          if (value != null) {
                            double amount = double.parse(value.last.toString());
                            worksheet!.values
                                .insertRowByKey(
                                    widget.args["listenerId"],
                                    [
                                      amount +
                                          ((int.parse(hoursStr) * 60) +
                                                  int.parse(minutesStr) +
                                                  (int.parse(secondsStr) > 14
                                                      ? 1
                                                      : 0)) *
                                              (widget.args["role"] == "listener"
                                                  ? settingsP!
                                                      .settings!.listenerPay
                                                  : settingsP!
                                                      .settings!.counsellorPay)
                                    ],
                                    fromColumn: value.length + 1)
                                .then((value) => print(value));
                          }
                        });
                        SessionService().updateSession({
                          "id": widget.args["chatRef"].id,
                          "status": "ended",
                          "totalTime": "$hoursStr:$minutesStr:$secondsStr",
                          "listenerAmount": ((int.parse(hoursStr) * 60) +
                                  int.parse(minutesStr) +
                                  (int.parse(secondsStr) > 14 ? 1 : 0)) *
                              (widget.args["role"] == "listener"
                                  ? settingsP!.settings!.listenerPay
                                  : settingsP!.settings!.counsellorPay),
                          "userAmount": ((int.parse(hoursStr) * 60) +
                                  int.parse(minutesStr) +
                                  (int.parse(secondsStr) > 14 ? 1 : 0)) *
                              (widget.args["role"] == "listener"
                                  ? settingsP!.settings!.listenerCharge
                                  : settingsP!.settings!.counsellorCharge)
                        });
                        // Navigator.of(context).pop();
                      });
                    },
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 22, color: Colors.white),
                  ),
                ),
                child1: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StText(
                          "Chating with ${widget.args["listenerName"].toString().split(" ")[0]}",
                          size: 16,
                          color: Colors.white,
                          weight: FontWeight.w600),
                      const SizedBox(height: 5),
                      StText("$hoursStr:$minutesStr:$secondsStr",
                          size: 13,
                          color: Colors.white,
                          weight: FontWeight.w600)
                    ],
                  ),
                )),
          ),
          // appBar: AppBar(
          //   leadingWidth: 40,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       StText(widget.args["name"], color: Colors.white),
          //       const StText("01.10", size: 16, color: Colors.white),
          //     ],
          //   ),
          //   leading: Padding(
          //     padding: const EdgeInsets.only(left: 8.0),
          //     child: IconButton(
          //         onPressed: () => Navigator.of(context).pop(),
          //         icon: const Icon(Icons.close)),
          //   ),
          //   backgroundColor: primaryColor,
          // ),
          body: Column(
            children: [
              // userP.getUser!.role == "speaker" &&
              //         userP.getUser!.walletBalance < 100
              //     ? Container(
              //         width: double.infinity,
              //         padding: const EdgeInsets.only(
              //             top: 10, left: 20, right: 20, bottom: 10),
              //         margin: const EdgeInsets.only(
              //             top: 22, left: 20, right: 20, bottom: 10),
              //         height: 100,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.grey[200],
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             const StText(
              //               "Running low on funds?",
              //               weight: FontWeight.w500,
              //             ),
              //             ElevatedButton(
              //                 style: ButtonStyle(
              //                     padding: MaterialStateProperty.all(
              //                         const EdgeInsets.symmetric(
              //                             vertical: 10, horizontal: 16)),
              //                     backgroundColor:
              //                         MaterialStateProperty.all(gradient1)),
              //                 onPressed: () {},
              //                 child: const StText(
              //                   "Recharge",
              //                   size: 14,
              //                   color: Colors.white,
              //                 ))
              //           ],
              //         ),
              //       )
              //     : SizedBox(height: 100),
              SizedBox(
                height: mq.size.height -
                    appbarHeight -
                    mq.viewInsets.bottom -
                    140 -
                    30,
                child: StreamBuilder(
                    stream: widget.args["chatRef"].snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      Map data = snapshot.data!.data() as Map;
                      List messageList = data["messageList"];
                      if (data["status"] == "ended") {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      }
                      if (data.containsKey("shouldPause") &&
                          data["shouldPause"] != shouldPause) {
                        shouldPause = data["shouldPause"];
                        if (shouldPause) {
                          timerSubscription!.pause();
                        } else {
                          timerSubscription!.resume();
                        }
                      }
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
                        border: Border.all(
                            width: .5, color: const Color(0xFF063763)),
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
                        backgroundColor: gradient1,
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
          )),
    );
  }
}
