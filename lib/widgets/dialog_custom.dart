import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:strangify/widgets/st_text.dart';

import '../constants.dart';
import '../screens/wallet_screen.dart';

Future showCustomDialog(
    BuildContext context, double height, Widget dialogWidget) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    //   barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(child: dialogWidget),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: child,
      );
    },
  );
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                    ))
              ],
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0, -10, 0),
              child: const Icon(Icons.remove_circle_outline,
                  color: Colors.red, size: 54)),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: StText(
              "Need minimum ₹35 to connect with a Listener",
              color: Colors.black,
              align: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
            width: 180,
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primaryColor)),
              child: const StText(
                "Recharge",
                color: Colors.white,
              ),
              onPressed: () async {
                //cancelRequest(requestId: rideRequestModel.id);
                Navigator.of(context).pushNamed(WalletScreen.routeName);
              },
            ),
          )
        ],
      ),
    );
  }
}
