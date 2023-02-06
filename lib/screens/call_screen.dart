import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/settings_provider.dart';
import '../services/session_service.dart';
import '../widgets/delete_confirm.dart';
import '../widgets/st_text.dart';

class CallScreen extends StatefulWidget {
  final Map args;
  static const routeName = "/callScreen";
  const CallScreen({super.key, required this.args});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with WidgetsBindingObserver {
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
  bool isLoading = true;
  String entryToken = "";
  int trackTime = 0;

  HMSSDK? hmsSDK;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => init());
    WidgetsBinding.instance.addObserver(this);
    settingsP = Provider.of<SettingsProvider>(context, listen: false);
    super.initState();
  }

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    //await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    // while ((await Permission.camera.isDenied)) {
    //   await Permission.camera.request();
    // }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  init() async {
    (widget.args["chatRef"] as DocumentReference)
        .get()
        .then((v) => setState(() {
              entryToken = (v.data()! as Map)[
                  widget.args["speakerId"] == currentUser!.uid
                      ? "listenerAuthToken"
                      : "speakerAuthToken"];
              print(entryToken);
            }));

    // void startTimer() {
    //   const onsec = Duration(seconds: 1);
    //   timer = Timer.periodic(onsec, (timer) {
    //     setState(() {
    //       trackTime++;
    //     });
    //   });
    // }

    getPermissions().then((value) async {
      HMSConfig config = HMSConfig(
          userName: widget.args[widget.args["speakerId"] == currentUser!.uid
              ? "listenerName"
              : "speakerName"],
          authToken: entryToken);
      hmsSDK = HMSSDK(
          hmsTrackSetting: HMSTrackSetting(
              audioTrackSetting: HMSAudioTrackSetting(
                  trackInitialState: HMSTrackInitState.UNMUTED)));
      await hmsSDK!.build();
      //hmsSDK.addUpdateListener(this);
//       HMSUpdateListener listeners;
// hmsSDK!.addUpdateListener(listener: listeners);
      hmsSDK!.join(config: config).then((value) => setState(() {
            isLoading = false;
            var timerStream = stopWatchStream();
            timerSubscription = timerStream.listen((int newTick) {
              if (mounted) {
                setState(() {
                  hoursStr = ((newTick / (60 * 60)) % 60)
                      .floor()
                      .toString()
                      .padLeft(2, '0');
                  minutesStr =
                      ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
                  secondsStr =
                      (newTick % 60).floor().toString().padLeft(2, '0');
                });
              }
            });
          }));
    });
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
      endSessionDialog(context, "Call", () async {
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

    streamController =
        StreamController<int>(onListen: startTimer, onCancel: stopTimer);

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
  void dispose() {
    hoursStr = "";
    minutesStr = "";
    secondsStr = "";
    timer!.cancel();
    timerSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
              stream: widget.args["chatRef"].snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                Map data = snapshot.data!.data() as Map;

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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StText(
                        widget.args[widget.args["speakerId"] == currentUser!.uid
                            ? "listenerName"
                            : "speakerName"],
                        color: Colors.white,
                        size: 30,
                        weight: FontWeight.w400),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: StText("$hoursStr:$minutesStr:$secondsStr",
                          color: Colors.white,
                          size: 30,
                          weight: FontWeight.w300),
                    ),
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("assets/login_phone.jpg"),
                    ),
                    const SizedBox(height: 130),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // hmsSDK!.getLocalPeer().then((value) async {
                            //   hmsSDK!.changeTrackState(
                            //       forRemoteTrack: await value!.getTrackById(
                            //           trackId: value.audioTrack!.trackId),
                            //       mute: !value.audioTrack!.isMute);
                            // });
                            hmsSDK!.toggleMicMuteState();
                          },
                          child: CircleAvatar(
                            //    backgroundColor: Colors.grey[200],
                            backgroundColor: Colors.grey[800],
                            radius: 30,
                            child: const Icon(CupertinoIcons.mic_off,
                                color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // hmsSDK!.getLocalPeer().then((value) async {
                            //   hmsSDK!.changeTrackState(
                            //       forRemoteTrack: await value!.getTrackById(
                            //           trackId: value.audioTrack!.trackId),
                            //       mute: !value.audioTrack!.isMute);
                            // });
                            hmsSDK!.switchAudioOutput(
                                audioDevice: HMSAudioDevice.AUTOMATIC);
                          },
                          child: CircleAvatar(
                            //    backgroundColor: Colors.grey[200],
                            backgroundColor: Colors.grey[800],
                            radius: 30,
                            child: const Icon(CupertinoIcons.speaker,
                                color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            endSessionDialog(context, "Call", () async {
                              worksheet!.values
                                  .rowByKey(widget.args["listenerId"])
                                  .then((value) {
                                if (value != null) {
                                  double amount =
                                      double.parse(value.last.toString());
                                  worksheet!.values
                                      .insertRowByKey(
                                          widget.args["listenerId"],
                                          [
                                            amount +
                                                ((int.parse(hoursStr) * 60) +
                                                        int.parse(minutesStr) +
                                                        (int.parse(secondsStr) >
                                                                14
                                                            ? 1
                                                            : 0)) *
                                                    (widget.args["role"] ==
                                                            "listener"
                                                        ? settingsP!.settings!
                                                            .listenerPay
                                                        : settingsP!.settings!
                                                            .counsellorPay)
                                          ],
                                          fromColumn: value.length + 1)
                                      .then((value) =>
                                          Navigator.of(context).canPop()
                                              ? Navigator.of(context).pop()
                                              : null);
                                }
                              });
                              SessionService().updateSession({
                                "id": widget.args["chatRef"].id,
                                "status": "ended",
                                "totalTime":
                                    "$hoursStr:$minutesStr:$secondsStr",
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
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 30,
                            child: Icon(CupertinoIcons.phone_down),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}

abstract class ListenerHMS {
  void onJoin({required HMSRoom room});

  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer});

  void onHMSError({required HMSException error});

  void onMessage({required HMSMessage message});

  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});

  void onReconnecting();

  void onReconnected();

  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest});

  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer});

  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice});
}
