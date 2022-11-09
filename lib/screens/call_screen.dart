import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strangify/constants.dart';

import '../widgets/st_text.dart';

class CallScreen extends StatefulWidget {
  static const routeName = "/callScreen";
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isLoading = true;
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
    getPermissions().then((value) {
      HMSConfig config = HMSConfig(
          userName: "Yash",
          authToken:
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjM2M2FmNjc0MjA4NzgwYmY2Njc3YzM1Iiwicm9vbV9pZCI6IjYzNmE3NzlmZTA4ODYzYTNmMmZiMDFmNyIsInVzZXJfaWQiOiJldXdvcmprcyIsInJvbGUiOiJyb29tLWhvc3QiLCJqdGkiOiJhNjY2ZDE1Yy01OTlkLTQ4YzItYmZlZC05NWI5ZjJlMTcwZjUiLCJ0eXBlIjoiYXBwIiwidmVyc2lvbiI6MiwiZXhwIjoxNjY4MDA5MzMyfQ.8uDAZywGTmhJAwbpDVd06sYeptTa8Q-Qkwt4hAPHK2U");
      HMSSDK hmsSDK = HMSSDK();
      hmsSDK.build();

      hmsSDK.join(config: config).then((value) => setState(() {
            isLoading = true;
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
              StText("Yash Test",
                  color: Colors.white, size: 30, weight: FontWeight.w400),
              Padding(
                padding: EdgeInsets.all(20),
                child: StText("02.13",
                    color: Colors.white, size: 30, weight: FontWeight.w300),
              ),
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/login_phone.jpg"),
              ),
              SizedBox(height: 130),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    //    backgroundColor: Colors.grey[200],
                    backgroundColor: Colors.grey[800],
                    radius: 30,
                    child: Icon(CupertinoIcons.mic_off, color: Colors.white),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {},
                      child: StText(
                        "Recharge",
                        size: 18,
                        color: Colors.black,
                      )),
                  CircleAvatar(
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
