import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:strangify/constants.dart';

import '../widgets/st_text.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = "/wallet";
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Container(
                  height: 250,
                  color: primaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 40, bottom: 30),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const StText(
                              "Home",
                              height: 1,
                              size: 18,
                              color: Colors.white,
                              //   weight: FontWeight.w500,
                            )
                          ],
                        ),
                      ),
                      const Center(
                        child: StText(
                          "₹ 671.13",
                          height: 1,
                          size: 38,
                          color: Colors.white,
                          weight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: const StText(
                            " Recharge",
                            size: 18,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 20, left: 6, right: 6),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 80, color: Colors.grey, height: 1),
                            const StText(
                              "   History   ",
                              size: 14,
                            ),
                            Container(width: 80, color: Colors.grey, height: 1)
                          ],
                        ),
                      ),
                      ListTile(
                        title: const StText("Added To Wallet",
                            color: Colors.black,
                            weight: FontWeight.w400,
                            size: 18),
                        subtitle: StText(
                            DateFormat("dd MMM yy hh:mm a")
                                .format(DateTime.now()),
                            //weight: FontWeight.w400,
                            color: Colors.grey[700],
                            size: 13),
                        trailing: const StText("₹100.00"),
                        leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.greenAccent[700],
                            child: const Icon(Icons.add,
                                size: 24, color: Colors.white)),
                      ),
                      ListTile(
                        title: const StText("Chat with Yash",
                            color: Colors.black,
                            weight: FontWeight.w400,
                            size: 18),
                        subtitle: StText(
                            DateFormat("dd MMM yy hh:mm a").format(
                                DateTime.now()
                                    .subtract(const Duration(seconds: 40002))),
                            //weight: FontWeight.w400,
                            color: Colors.grey[700],
                            size: 13),
                        trailing: const StText("₹100.00"),
                        leading: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.remove,
                                size: 24, color: Colors.white)),
                      ),
                      ListTile(
                        title: const StText("Added To Wallet",
                            color: Colors.black,
                            weight: FontWeight.w400,
                            size: 18),
                        subtitle: StText(
                            DateFormat("dd MMM yy hh:mm a").format(
                                DateTime.now()
                                    .subtract(const Duration(seconds: 100000))),
                            //weight: FontWeight.w400,
                            color: Colors.grey[700],
                            size: 13),
                        trailing: const StText("₹600.00"),
                        leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.greenAccent[700],
                            child: const Icon(Icons.add,
                                size: 24, color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 220,
              child: SizedBox(
                height: 68,
                width: MediaQuery.of(context).size.width,
                child: const Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 5,
                    child: ListTile(
                      title: StText("Offers",
                          color: primaryColor,
                          weight: FontWeight.w500,
                          size: 20),
                      trailing: Icon(Icons.arrow_forward_ios),
                      leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: primaryColor,
                          child: Icon(Icons.percent_rounded,
                              size: 18, color: Colors.white)),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
