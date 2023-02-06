import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/screens/listener_detail_screen.dart';
import 'package:strangify/screens/wallet_screen.dart';
import 'package:strangify/services/listener_services.dart';
import 'package:strangify/widgets/home_basic_tile.dart';
import 'package:strangify/widgets/home_drawer.dart';
import 'package:strangify/widgets/st_header.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/st_text.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> listeners = [];
  List<User> counsellors = [];
  bool listenerSelected = true;
  @override
  void initState() {
    ListenerService().fetchListeners().then((value) => setState(() {
          listeners = value;
        }));

    ListenerService().fetchCounsellors().then((value) => setState(() {
          counsellors = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
        drawer: const HomeDrawer(),
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 90),
          child: StHeader(
              child1: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: StText(listenerSelected ? "Listeners" : "Counsellors",
                  color: Colors.white, weight: FontWeight.w600),
            ),
          )),
        ),
        body: RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              if (listenerSelected) {
                listeners.clear();
                ListenerService().fetchListeners().then((value) => setState(() {
                      listeners = value;
                    }));
              } else {
                counsellors.clear();
                ListenerService()
                    .fetchCounsellors()
                    .then((value) => setState(() {
                          counsellors = value;
                        }));
              }
            },
            child: Stack(
              children: [
                listenerSelected
                    ? ListView.builder(
                        itemCount: listeners.length,
                        padding: const EdgeInsets.only(top: 15),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ListenerDetailScreen.routeName,
                                  arguments: listeners[index]);
                            },
                            child: HomeBasicTile(user: listeners[index]),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: counsellors.length,
                        padding: const EdgeInsets.only(top: 15),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ListenerDetailScreen.routeName,
                                  arguments: counsellors[index]);
                            },
                            child: HomeBasicTile(user: counsellors[index]),
                          );
                        },
                      ),
                Positioned(
                  bottom: 30,
                  width: mq.size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              listenerSelected = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 140,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: !listenerSelected ? null : gradient1,
                                border: Border.all(color: gradient1),
                                borderRadius: BorderRadius.circular(20)),
                            child: StText("Listeners",
                                size: 16,
                                color: !listenerSelected
                                    ? greyColor
                                    : Colors.white),
                          )),
                      InkWell(
                          onTap: () {
                            setState(() {
                              listenerSelected = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 140,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: listenerSelected ? null : gradient1,
                                border: Border.all(color: gradient1),
                                borderRadius: BorderRadius.circular(20)),
                            child: StText("Counsellors",
                                size: 16,
                                color: listenerSelected
                                    ? greyColor
                                    : Colors.white),
                          ))
                    ],
                  ),
                )
              ],
            )));
  }
}
