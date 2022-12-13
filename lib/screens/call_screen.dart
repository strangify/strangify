import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/st_text.dart';

class CallScreen extends StatefulWidget {
  final Map args;
  static const routeName = "/callScreen";
  const CallScreen({super.key, required this.args});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isLoading = true;
  String entryToken = "";
  int trackTime = 0;
  Timer? timer;
  HMSSDK? hmsSDK;
  @override
  void initState() {
    //  init();
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
    widget.args["chatRef"].get().then((v) => setState(() {
          entryToken = v.data()![widget.args["name"] == "Annonymous User"
              ? "listenerAuthToken"
              : "speakerAuthToken"];
        }));

    void startTimer() {
      const onsec = Duration(seconds: 1);
      timer = Timer.periodic(onsec, (timer) {
        setState(() {
          trackTime++;
        });
      });
    }

    getPermissions().then((value) {
      HMSConfig config =
          HMSConfig(userName: widget.args["name"], authToken: entryToken);
      hmsSDK = HMSSDK(
          hmsTrackSetting: HMSTrackSetting(
              audioTrackSetting: HMSAudioTrackSetting(
                  trackInitialState: HMSTrackInitState.UNMUTED)));
      hmsSDK!.build();
//       HMSUpdateListener listeners;
// hmsSDK!.addUpdateListener(listener: listeners);
      hmsSDK!.join(config: config).then((value) => setState(() {
            isLoading = false;
            startTimer();
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const StText("Yash Test",
                  color: Colors.white, size: 30, weight: FontWeight.w400),
              Padding(
                padding: const EdgeInsets.all(20),
                child: StText(trackTime.toString(),
                    color: Colors.white, size: 30, weight: FontWeight.w300),
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
                      hmsSDK!.switchAudio();
                    },
                    child: CircleAvatar(
                      //    backgroundColor: Colors.grey[200],
                      backgroundColor: Colors.grey[800],
                      radius: 30,
                      child: const Icon(CupertinoIcons.mic_off,
                          color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {},
                      child: const StText(
                        "Recharge",
                        size: 18,
                        color: Colors.black,
                      )),
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(CupertinoIcons.phone_down),
                  ),
                ],
              )
            ],
          ),
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
