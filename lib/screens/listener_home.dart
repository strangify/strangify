import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/helpers/methods.dart';
import 'package:strangify/screens/call_screen.dart';
import 'package:strangify/widgets/home_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/st_header.dart';
import '../widgets/st_text.dart';
import 'chat_screen.dart';

class ListenerHomeScreen extends StatefulWidget {
  static const routeName = "/ListenerHome";
  const ListenerHomeScreen({super.key});

  @override
  State<ListenerHomeScreen> createState() => _ListenerHomeScreenState();
}

class _ListenerHomeScreenState extends State<ListenerHomeScreen> {
//  List sessions = [];
  auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    final MediaQueryData mq = MediaQuery.of(context);
    double appbarHeight = AppBar().preferredSize.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: const HomeDrawer(),
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 90),
              child: StHeader(
                  child1: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: StText("Home",
                      color: Colors.white, weight: FontWeight.w600),
                ),
              )),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                height: 52,
                child: FloatingActionButton.extended(
                  backgroundColor: gradient1,
                  extendedPadding: const EdgeInsets.all(10),
                  onPressed: () {},
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: StText(
                          "Online",
                          color: Colors.white,
                          size: 17,
                          weight: FontWeight.w500,
                        ),
                      ),
                      CupertinoSwitch(
                        // This bool value toggles the switch.
                        value: isActive,
                        thumbColor: Colors.white70,
                        trackColor: CupertinoColors.systemRed,
                        activeColor: CupertinoColors.systemGreen,
                        onChanged: (bool? value) async {
                          setState(() {
                            isActive = value!;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser!.uid)
                                .update({"isOnline": value});
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('session')
                  .where("status", isEqualTo: "waiting")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                List<QueryDocumentSnapshot> sessions = snapshot.data!.docs;

                return sessions.isEmpty
                    ? Column(
                        children: [
                          Lottie.asset("assets/searching.json"),
                          const StText("Waiting for Speakers' requests")
                        ],
                      )
                    : ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, i) {
                          int secs =
                              settingsProvider.settings!.sessionExpiry.toInt();

                          Future.delayed(
                              const Duration(seconds: 1),
                              () => setState(() {
                                    secs = secs - 1;
                                  }));
                          return DateTime.now()
                                      .difference(
                                          (sessions[i]["time"].toDate()))
                                      .inSeconds >
                                  settingsProvider.settings!.sessionExpiry
                                      .toInt()
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20, bottom: 20),
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20, bottom: 10),
                                  height: 168,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  //  / width: MediaQuery.of(context).size.width,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                StText(
                                                  "Anoymous",
                                                  size: 20,
                                                ),
                                                SizedBox(height: 6),
                                                StText(
                                                    "wants to connect with you..",
                                                    size: 15),
                                              ],
                                            ),
                                            StText(
                                                sessions[i]["type"]
                                                    .toString()
                                                    .capitalize(),
                                                color: primaryColor,
                                                size: 20,
                                                weight: FontWeight.w500),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('session')
                                                        .doc(sessions[i].id)
                                                        .update({
                                                      "status": "rejected"
                                                    });
                                                  },
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.red),
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white)),
                                                  child: const StText("Reject",
                                                      color: Colors.white)),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      var chatRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'session')
                                                              .doc(sessions[i]
                                                                  .id);
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(currentUser!.uid)
                                                          .update({
                                                        "isOnline": false
                                                      });
                                                      chatRef.update(
                                                          {"status": "active"});
                                                      if (sessions[i]["type"] ==
                                                          "chat") {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                ChatScreen
                                                                    .routeName,
                                                                arguments: {
                                                              "listenerName":
                                                                  sessions[i][
                                                                      "listenerName"],
                                                              "speakerName":
                                                                  sessions[i][
                                                                      "speakerName"],
                                                              "speakerId":
                                                                  sessions[i][
                                                                      'speakerId'],
                                                              "listenerId":
                                                                  sessions[i][
                                                                      'listenerId'],
                                                              "chatRef": chatRef
                                                            });
                                                      } else {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                CallScreen
                                                                    .routeName,
                                                                arguments: {
                                                              "listenerName":
                                                                  sessions[i][
                                                                      "listenerName"],
                                                              "speakerName":
                                                                  sessions[i][
                                                                      "speakerName"],
                                                              "speakerId":
                                                                  sessions[i][
                                                                      'speakerId'],
                                                              "listenerId":
                                                                  sessions[i][
                                                                      'listenerId'],
                                                              "chatRef": chatRef
                                                            });
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.greenAccent[
                                                                    700]),
                                                        foregroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Colors.white)),
                                                    child: const StText(
                                                        "Accept",
                                                        color: Colors.white))),
                                          ],
                                        ),
                                        StText(
                                          "*Expiring in ${secs - DateTime.now().difference((sessions[i]["time"].toDate())).inSeconds} seconds*",
                                          size: 16,
                                          weight: FontWeight.w500,
                                        )
                                      ]),
                                );
                        });
              },
            )
            // body: ListView.builder(
            //   itemCount: listeners.length,
            //   shrinkWrap: true,
            //   padding: EdgeInsets.only(top: 15),
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //       onTap: () {
            //         Navigator.of(context).pushNamed(
            //             ListenerDetailScreen.routeName,
            //             arguments: listeners[index]);
            //       },
            //       child: Card(
            //         elevation: 4,
            //         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10)),
            //         child: Container(
            //           height: 95,
            //           padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            //           decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(10)),
            //           child: Row(
            //             children: [
            //               Row(
            //                 children: [
            //                   Card(
            //                     margin: EdgeInsets.symmetric(
            //                         vertical: 4, horizontal: 4),
            //                     elevation: 1,
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(10)),
            //                     child: Hero(
            //                       tag: "pfp",
            //                       child: Container(
            //                         width: 75,
            //                         decoration: BoxDecoration(
            //                             image: DecorationImage(
            //                                 fit: BoxFit.cover,
            //                                 image: NetworkImage(
            //                                     listeners[index].imageUrl!)),
            //                             color: Colors.grey[300],
            //                             borderRadius:
            //                                 BorderRadius.circular(10)),
            //                       ),
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 8, vertical: 5.8),
            //                     child: Column(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Row(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             SizedBox(
            //                               width: mq.size.width - 175,
            //                               child: StText(
            //                                 listeners[index].name!,
            //                                 weight: FontWeight.w500,
            //                                 size: 16,
            //                               ),
            //                             ),
            //                             Container(
            //                               // margin: const EdgeInsets.symmetric(
            //                               //     vertical: 10),
            //                               padding: const EdgeInsets.symmetric(
            //                                   horizontal: 6, vertical: 3),
            //                               decoration: BoxDecoration(
            //                                   color: !listeners[index].isOnline!
            //                                       ? Colors.red
            //                                       : Colors.green,
            //                                   borderRadius:
            //                                       BorderRadius.circular(4)),
            //                               child: StText(
            //                                 !listeners[index].isOnline!
            //                                     ? "Offline"
            //                                     : "Online",
            //                                 size: 10,
            //                                 spacing: 1.1,
            //                                 weight: FontWeight.w500,
            //                                 color: Colors.white,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                         SizedBox(
            //                           width: mq.size.width - 150,
            //                           child: Padding(
            //                             padding:
            //                                 const EdgeInsets.only(bottom: 3),
            //                             child: StText(
            //                               listeners[index].description!,
            //                               maxLines: 2,
            //                               height: 1,
            //                               size: 12,
            //                             ),
            //                           ),
            //                         ),
            //                         SizedBox(
            //                             width: mq.size.width - 200,
            //                             child: Row(
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceBetween,
            //                               children: [
            //                                 Row(
            //                                   children: [
            //                                     Icon(
            //                                       Icons.star,
            //                                       size: 16,
            //                                       color: Colors.amber[600],
            //                                     ),
            //                                     StText(
            //                                       " -",
            //                                       weight: FontWeight.w500,
            //                                       size: 12,
            //                                     ),
            //                                   ],
            //                                 ),
            //                                 Container(
            //                                   transform:
            //                                       Matrix4.translationValues(
            //                                           0, 2, 0),
            //                                   decoration: BoxDecoration(
            //                                     borderRadius:
            //                                         BorderRadius.circular(4),
            //                                     border: Border.all(
            //                                         color: primaryColor),
            //                                   ),
            //                                   padding: EdgeInsets.symmetric(
            //                                       vertical: 2, horizontal: 6),
            //                                   child: StText(
            //                                     "${listeners[index].gender.toString()[0].toUpperCase()} - ${listeners[index].age}Y",
            //                                     weight: FontWeight.bold,
            //                                     size: 11,
            //                                     color: primaryColor,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ))
            //                       ],
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // )));
            ));
  }
}
