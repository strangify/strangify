import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strangify/widgets/st_text.dart';

class NewCall extends StatefulWidget {
  const NewCall({super.key});

  @override
  State<NewCall> createState() => _NewCallState();
}

class _NewCallState extends State<NewCall> {
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
              const StText("Caller's Name",
                  color: Colors.white, size: 30, weight: FontWeight.w300),
              const Padding(
                padding: EdgeInsets.all(20),
                child: StText("0.00",
                    color: Colors.white, size: 30, weight: FontWeight.w300),
              ),
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
              const SizedBox(height: 130),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    //    backgroundColor: Colors.grey[200],
                    backgroundColor: Colors.grey[800],
                    radius: 30,
                    child:
                        const Icon(CupertinoIcons.mic_off, color: Colors.white),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: Icon(CupertinoIcons.phone_down),
                  ),
                  CircleAvatar(
                    //    backgroundColor: Colors.grey[200],
                    backgroundColor: Colors.grey[800],
                    radius: 30,
                    child: const Icon(CupertinoIcons.speaker_2,
                        color: Colors.white),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Center(
                                    child: Text(
                                  'Recharge',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                )),
                                const SizedBox(
                                  height: 28,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Enter the Amount',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            const Text(
                                              '₹',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(width: 10),
                                            const SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: TextField(
                                                //   controller: amountController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 10.0),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                                const Text(
                                  "(Min ₹150 )",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  "* Get 20% off on Recharge above ₹1000 ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 25),
                                Center(
                                    child: ElevatedButton(
                                  child: const Text('Pay Amount'),
                                  onPressed: () {},
                                ))
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: const Text(
                  'Choose Option',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Connecting',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectingSheet extends StatelessWidget {
  final DocumentReference chatRef;
  const ConnectingSheet({super.key, required this.chatRef});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      color: Colors.grey.withOpacity(.8),
                      offset: const Offset(3, 2),
                      blurRadius: 7)
                ]),
            // height: MediaQuery.of(context).size.height / 2.5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 135,
                        child: Lottie.asset("assets/connecting.json"),
                      ),
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("assets/logo.png"),
                      ),
                    ],
                  ),
                  const Text(
                    "Waiting for Listener to connect",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      chatRef.update({"status": "cancelled"});
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
