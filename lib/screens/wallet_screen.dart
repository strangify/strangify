import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:strangify/constants.dart';
import 'package:strangify/helpers/methods.dart';
import 'package:strangify/providers/user_provider.dart';

import 'package:strangify/services/function_service.dart';
import '../providers/settings_provider.dart';
import '../widgets/st_header.dart';
import '../widgets/st_text.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = "/wallet";
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController amountController = TextEditingController();
  List<Map> sessions = [];
  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection("session")
        .where("status", isEqualTo: "ended")
        .where(
            "${userProvider.getUser!.role == "speaker" ? "speaker" : "listener"}Id",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        sessions.add(element.data());
      }
      sessions.reversed;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userP = Provider.of<UserProvider>(context);
    SettingsProvider settingsP = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: StHeader(
            hideWallet: true,
            child2: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 22, color: Colors.white),
            ),
            child1: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/coin.png", height: 34),
                      const SizedBox(width: 10),
                      StText(
                        userP.getUser!.walletBalance.toString(),
                        height: 1,
                        size: 32,
                        color: Colors.white,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                )),
          )),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Container(
            //   height: 180,
            //   color: primaryColor,
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(
            //             left: 16, right: 16, top: 42, bottom: 30),
            //         child: Row(
            //           children: [
            //             GestureDetector(
            //               onTap: () => Navigator.of(context).pop(),
            //               child: const Icon(
            //                 Icons.arrow_back_ios_new_rounded,
            //                 size: 24,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             const SizedBox(width: 12),
            //             const StText(
            //               "Wallet",
            //               height: 1,
            //               size: 18,
            //               color: Colors.white,
            //               //   weight: FontWeight.w500,
            //             )
            //           ],
            //         ),
            //       ),
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset("assets/coin.png", height: 40),
            //           SizedBox(width: 10),
            //           StText(
            //             "671.13",
            //             height: 1,
            //             size: 36,
            //             color: Colors.white,
            //             weight: FontWeight.w300,
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  140 -
                  MediaQuery.of(context).viewInsets.bottom,
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 20, left: 6, right: 6),
                children: [
                  // if (userP.getUser!.role == "speaker")
                  //   Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 10, horizontal: 10),
                  //       child: TextFormField(
                  //         controller: amountController,
                  //         autovalidateMode: AutovalidateMode.onUserInteraction,
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return '*Amount is Required';
                  //           }
                  //           if (double.parse(value) < 70) {
                  //             return '*Minimum Amount is ₹70';
                  //           }
                  //           return null;
                  //         },
                  //         onFieldSubmitted: (_) {
                  //           FocusScope.of(context).unfocus();
                  //         },
                  //         cursorColor: const Color(0xFF080808),
                  //         cursorWidth: 1.5,
                  //         cursorHeight: 16,
                  //         keyboardType: TextInputType.phone,
                  //         inputFormatters: [
                  //           FilteringTextInputFormatter.digitsOnly,
                  //         ],
                  //         style: const TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //             height: 1),
                  //         decoration: InputDecoration(
                  //             hintText: "Coupon Code",
                  //             hintStyle: const TextStyle(
                  //                 fontSize: 16,
                  //                 height: 1,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.black),
                  //             errorBorder: errorBorder,
                  //             focusedBorder: walletBorder,
                  //             enabledBorder: walletBorder,
                  //             focusedErrorBorder: errorBorder,
                  //             border: walletBorder),
                  //       )),

                  // if (userP.getUser!.role == "speaker")
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 16),
                  //     child: ElevatedButton(
                  //         onPressed: () {
                  // if (amountController.text.isEmpty) {
                  //   return;
                  // } else {
                  //   FirebaseFirestore.instance
                  //       .collection("coupons")
                  //       .where("_id",
                  //           isEqualTo: amountController.text.trim())
                  //       .get();

                  // }
                  // FirebaseService.CREATE_OFFER.call(<String, dynamic>{
                  //   'amount':
                  //       (double.parse(amountController.text) * 100)
                  //           .toInt()
                  //           .toString(),
                  //   'currency': 'inr',
                  //   "receipt": docRef.id
                  // }).then((response) async {
                  //   print(response.data);
                  //   var options = {
                  //     'key': "rzp_test_s5X5ImuVQBVKlA",
                  //     'amount':
                  //         double.parse(amountController.text) * 100,
                  //     'name': 'Strangify Technologies.',
                  //     'order_id': response.data["id"],
                  //     'retry': {'enabled': true, 'max_count': 1},
                  //     'send_sms_hash': true,
                  //     'prefill': {
                  //       'contact': userP.user!.phone,
                  //       'walletId': docRef.id
                  //     },
                  //     'external': {
                  //       'wallets': ['paytm']
                  //     }
                  //   };

                  //   print(
                  //       "itent response: " + response.data.toString());
                  //   Stripe.instance
                  //       .initPaymentSheet(
                  //           paymentSheetParameters:
                  //               SetupPaymentSheetParameters(
                  //         customerId: "cus_N1AOJss1IJP667",
                  //         paymentIntentClientSecret:
                  //             response.data["client_secret"],
                  //         merchantDisplayName: 'Strangify',
                  //       ))
                  //       .then((value) async => await Stripe.instance
                  //               .presentPaymentSheet()
                  //               .then((value) {
                  //             FirebaseService.CONFIRM_PAYMENT_INTENT
                  //                 .call(<String, dynamic>{
                  //               "userId": FirebaseAuth
                  //                   .instance.currentUser!.uid,
                  //               "paymentIntentId": response.data["id"],
                  //             }).then((value) => print(value.data));
                  //           }));
                  //   // hideLoading();
                  //   // confirmDialog(
                  //   //     response.data["client_secret"],
                  //   //     response.data["payment_method"],
                  //   //     response.data[
                  //   //         "id"]); //function for confirmation for payment
                  // }).catchError((error) {
                  //   print("intent error: " + error.toString());
                  //   // hideLoading();
                  //   });

                  // FirebaseService.CREATE_PAYOUT.call(<String, dynamic>{
                  //   'amount': 200,
                  //   "accountid": "acct_1MHYINSIZzJMKNmL",
                  //   'currency': 'inr',
                  // }).then((response) {
                  //   print(
                  //       "itent response: " + response.data.toString());
                  // });
                  // },
                  // style: ButtonStyle(
                  //     padding: MaterialStateProperty.all(
                  //         const EdgeInsets.symmetric(
                  //             vertical: 10, horizontal: 16)),
                  //     backgroundColor:
                  //         MaterialStateProperty.all(primaryColor)),
                  // child: const StText(
                  //   "Recharge",
                  //   color: Colors.white,
                  // )),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
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
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        if (sessions[index].containsKey("totalTime") &&
                            sessions[index]["totalTime"] != "00:00:00") {
                          return ListTile(
                            title: StText(
                                "${sessions[index]["type"].toString().capitalize()} Session",
                                color: Colors.black,
                                weight: FontWeight.w400,
                                size: 18),
                            subtitle: StText(
                                DateFormat("dd MMM yy hh:mm a")
                                    .format(sessions[index]['time'].toDate()),
                                //weight: FontWeight.w400,
                                color: Colors.grey[700],
                                size: 13),
                            trailing: StText(userP.getUser!.role == "speaker"
                                ? sessions[index]["userAmount"]
                                : sessions[index]["listenerAmount"]),
                            leading: userP.getUser!.role == "speaker"
                                ? const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.remove,
                                        size: 24, color: Colors.white))
                                : CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.greenAccent[700],
                                    child: const Icon(Icons.add,
                                        size: 24, color: Colors.white)),
                          );
                        } else {
                          return SizedBox();
                        }
                      })
                  // ListTile(
                  //   title: const StText("Chat with Yash",
                  //       color: Colors.black, weight: FontWeight.w400, size: 18),
                  //   subtitle: StText(
                  //       DateFormat("dd MMM yy hh:mm a").format(DateTime.now()
                  //           .subtract(const Duration(seconds: 40002))),
                  //       //weight: FontWeight.w400,
                  //       color: Colors.grey[700],
                  //       size: 13),
                  //   trailing: const StText("₹100.00"),
                  //   leading: const CircleAvatar(
                  //       radius: 16,
                  //       backgroundColor: Colors.red,
                  //       child:
                  //           Icon(Icons.remove, size: 24, color: Colors.white)),
                  // ),
                  // ListTile(
                  //   title: const StText("Added To Wallet",
                  //       color: Colors.black, weight: FontWeight.w400, size: 18),
                  //   subtitle: StText(
                  //       DateFormat("dd MMM yy hh:mm a").format(DateTime.now()
                  //           .subtract(const Duration(seconds: 100000))),
                  //       //weight: FontWeight.w400,
                  //       color: Colors.grey[700],
                  //       size: 13),
                  //   trailing: const StText("₹600.00"),
                  //   leading: CircleAvatar(
                  //       radius: 16,
                  //       backgroundColor: Colors.greenAccent[700],
                  //       child: const Icon(Icons.add,
                  //           size: 24, color: Colors.white)),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
