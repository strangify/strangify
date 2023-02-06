import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/screens/login_screen.dart';
import 'package:strangify/widgets/st_text.dart';
import 'package:strangify/widgets/support_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants.dart';
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';
import '../screens/become_a_listener_screen.dart';
import '../screens/wallet_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Drawer(
      width: 260,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Positioned(
                  left: -30,
                  top: -30,
                  child: Image.asset("assets/signup-1.png", height: 120)),
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
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
                    Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ListTile(
                          title: StText(
                              'Welcome,\n${userProvider.getUser!.name ?? "Anonymous User"}',
                              size: 18,
                              weight: FontWeight.w400,
                              height: 1.5),
                        )),
                  ],
                ),
              ),
              Positioned(
                  right: 15,
                  top: 100,
                  child: Image.asset("assets/signup-2.png", height: 80)),
            ],
          ),
          ListTile(
            tileColor: primaryColor,
            dense: true,
            minLeadingWidth: 30,
            leading: const Icon(Icons.wallet, color: Colors.white, size: 20),
            title: const StText("Wallet",
                color: Colors.white, size: 16, weight: FontWeight.w500),
            onTap: () =>
                Navigator.of(context).pushNamed(WalletScreen.routeName),
          ),
          if (userProvider.getUser!.role == "speaker")
            Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  tileColor: primaryColor,
                  dense: true,
                  minLeadingWidth: 30,
                  leading:
                      const Icon(Icons.group, color: Colors.white, size: 20),
                  title: const StText("Become A Listener",
                      color: Colors.white, size: 16, weight: FontWeight.w500),
                  onTap: () {
                    Navigator.pushNamed(
                        context, BecomeAListenerScreen.routeName,
                        arguments: true);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: primaryColor,
                  dense: true,
                  minLeadingWidth: 30,
                  leading:
                      const Icon(Icons.group, color: Colors.white, size: 20),
                  title: const StText("Become A Counsellor",
                      color: Colors.white, size: 16, weight: FontWeight.w500),
                  onTap: () {
                    Navigator.pushNamed(
                        context, BecomeAListenerScreen.routeName,
                        arguments: false);
                  },
                ),
                ListTile(
                  dense: true,
                  minLeadingWidth: 30,
                  leading: const Icon(Icons.history, size: 20),
                  title: const StText("Recently Connected",
                      color: greyColor, size: 16, weight: FontWeight.w500),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MessageScreen(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),

          ListTile(
            dense: true,
            minLeadingWidth: 30,
            leading: const Icon(Icons.support_agent, size: 20),
            title: const StText("Support",
                color: greyColor, size: 16, weight: FontWeight.w500),
            onTap: () {
              supportEmailDialog(context);
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.group_outlined),
          //   title: const StText(
          //     "Users",
          //     color: greyColor,
          //     size: 20,
          //     weight: FontWeight.w500,
          //   ),
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => MessageScreen(),
          //     //   ),
          //     // );
          //   },
          // ),
          ListTile(
            dense: true,
            minLeadingWidth: 30,
            leading: const Icon(CupertinoIcons.lock, size: 20),
            title: const StText("Privacy Policy",
                color: greyColor, size: 16, weight: FontWeight.w500),
            onTap: () async {
              if (userProvider.getUser!.role == "speaker") {
                await launchUrlString(settingsProvider.settings!.usersPrivacy);
              } else {
                await launchUrlString(
                    settingsProvider.settings!.listenerPrivacy);
              }
            },
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 30,
            leading: const Icon(CupertinoIcons.doc_on_doc, size: 20),
            title: const StText("Terms & Conditions",
                color: greyColor, size: 16, weight: FontWeight.w500),
            onTap: () async {
              if (userProvider.getUser!.role == "speaker") {
                await launchUrlString(settingsProvider.settings!.usersTerms);
              } else {
                await launchUrlString(settingsProvider.settings!.listenerTerms);
              }
            },
          ),
          // Container(
          //   color: Colors.grey,
          //   height: 3,
          //   width: double.infinity,
          // ),

          const SizedBox(height: 10),
          Container(
            color: Colors.grey,
            height: 1,
            width: double.infinity,
          ),
          ListTile(
              dense: true,
              minLeadingWidth: 30,
              leading: const Icon(Icons.logout, size: 20),
              title: const StText("Logout",
                  color: greyColor, size: 16, weight: FontWeight.w500),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName));
              }),
          // Divider(
          //   color: grayColor,
          // ),
          // ListTile(
          //   leading: Icon(Icons.close),
          //   title: Text(
          //     appLocalization.translate('logout'),
          //     style: TextStyle(
          //       color: grayColor,
          //       fontSize: 20.0,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          //   onTap: () async {
          //     bool res = await showConfirmDialog(
          //       context,
          //       appLocalization.translate('confirm_logout'),
          //       positiveText: appLocalization.translate('yes'),
          //       negativeText: appLocalization.translate('no'),
          //     );
          //     if (res) {
          //       EasyDebounce.debounce(
          //           "tag", Duration(seconds: 1), () => logout(context, ref));
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
