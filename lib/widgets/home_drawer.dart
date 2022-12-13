import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/screens/login_screen.dart';
import 'package:strangify/widgets/st_text.dart';

import '../../constants.dart';
import '../providers/user_provider.dart';
import '../screens/become_a_listener_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
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
                ListTile(
                  title: StText(
                      'Welcome,\nAnonymous User\n${userProvider.getUser?.phone}',
                      size: 19,
                      weight: FontWeight.w500,
                      height: 1.5),
                ),
              ],
            ),
          ),
          ListTile(
            tileColor: primaryColor,
            leading: const Icon(
              Icons.wallet,
              color: Colors.white,
            ),
            title: const StText(
              "Wallet",
              color: Colors.white,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => BookingScreen(),
              //     ));
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: primaryColor,
            leading: const Icon(
              Icons.group,
              color: Colors.white,
            ),
            title: const StText(
              "Become A Listener",
              color: Colors.white,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.pushNamed(context, BecomeAListenerScreen.routeName,
                  arguments: true);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: primaryColor,
            leading: const Icon(
              Icons.group,
              color: Colors.white,
            ),
            title: const StText(
              "Become A Counsellor",
              color: Colors.white,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.pushNamed(context, BecomeAListenerScreen.routeName,
                  arguments: false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const StText(
              "Recently Connected",
              color: greyColor,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MessageScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const StText(
              "Support",
              color: greyColor,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => GalleryScreen(),
              //   ),
              // );
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
            leading: const Icon(CupertinoIcons.lock),
            title: const StText(
              "Privacy Policy",
              color: greyColor,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MessageScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.doc_on_doc),
            title: const StText(
              "Terms & Conditions",
              color: greyColor,
              size: 18,
              weight: FontWeight.w500,
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MessageScreen(),
              //   ),
              // );
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
              leading: const Icon(Icons.logout),
              title: const StText(
                "Logout",
                color: greyColor,
                size: 20,
                weight: FontWeight.w500,
              ),
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
