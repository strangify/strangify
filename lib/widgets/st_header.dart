import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/providers/user_provider.dart';
import '../helpers/methods.dart';
import '../screens/wallet_screen.dart';
import 'st_text.dart';

class StHeader extends StatelessWidget {
  final Widget? child1;
  final Widget? child2;
  final bool? hideWallet;
  const StHeader(
      {super.key, required this.child1, this.child2, this.hideWallet});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset("assets/header-bg.png",
            fit: BoxFit.cover, height: 90, width: double.infinity),
        Positioned(
          top: 30,
          left: 20,
          width: MediaQuery.of(context).size.width - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              child2 ??
                  GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu, size: 20, color: Colors.white)),
              hideWallet == true
                  ? SizedBox()
                  : Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        margin: const EdgeInsets.only(
                            top: 11, bottom: 11, right: 10),
                        child: Row(
                          children: const [
                            Icon(Icons.history, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            StText("History",
                                color: Colors.white,
                                size: 12,
                                weight: FontWeight.w500)
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(WalletScreen.routeName);
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.only(right: 6),
                            child: Row(
                              children: [
                                Icon(Icons.wallet,
                                    size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                StText(
                                    formatNumber(
                                        userProvider.getUser!.walletBalance),
                                    color: Colors.white,
                                    size: 12,
                                    weight: FontWeight.w500)
                              ],
                            ),
                          ))
                    ]),
            ],
          ),
        ),
        child1 ?? SizedBox(),
      ],
    );
  }
}
