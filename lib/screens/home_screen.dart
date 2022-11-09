import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/screens/listener_detail_screen.dart';
import 'package:strangify/services/listener_services.dart';
import 'package:strangify/widgets/home_drawer.dart';

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
  @override
  void initState() {
    ListenerService().fetchListeners().then((value) => setState(() {
          listeners = value;
        }));
    Provider.of<UserProvider>(context, listen: false).refreshUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final MediaQueryData mq = MediaQuery.of(context);
    double appbarHeight = AppBar().preferredSize.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: HomeDrawer(),
            appBar: AppBar(
              actions: [
                Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(8),
                  //   border: Border.all(color: Colors.white),
                  // ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.only(top: 11, bottom: 11, right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 20),
                      SizedBox(width: 6),
                      StText(
                        "History",
                        color: Colors.white,
                        size: 15,
                        weight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.only(top: 11, bottom: 11, right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.wallet, size: 20),
                      SizedBox(width: 10),
                      StText(
                        "0.00",
                        color: Colors.white,
                        size: 15,
                        weight: FontWeight.w500,
                      )
                    ],
                  ),
                )
              ],
              backgroundColor: primaryColor,
              // bottom: TabBar(
              //   //  labelColor: primaryColor,
              //   indicatorColor: primaryColor,
              //   indicatorWeight: 3,
              //   tabs: [
              //     Tab(
              //       child: StText(
              //         "Listeners",
              //         color: Colors.white,
              //       ),
              //     ),
              //     Tab(
              //       child: StText(
              //         "Counsellors",
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            body: ListView.builder(
              itemCount: listeners.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        ListenerDetailScreen.routeName,
                        arguments: listeners[index]);
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 95,
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Hero(
                                  tag: "pfp",
                                  child: Container(
                                    width: 75,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                listeners[index].imageUrl!)),
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5.8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: mq.size.width - 175,
                                          child: StText(
                                            listeners[index].name!,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                        ),
                                        Container(
                                          // margin: const EdgeInsets.symmetric(
                                          //     vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                              color: !listeners[index].isOnline!
                                                  ? Colors.red
                                                  : Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: StText(
                                            !listeners[index].isOnline!
                                                ? "Offline"
                                                : "Online",
                                            size: 10,
                                            spacing: 1.1,
                                            weight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: mq.size.width - 150,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: StText(
                                          listeners[index].description!,
                                          maxLines: 2,
                                          height: 1,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: mq.size.width - 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: Colors.amber[600],
                                                ),
                                                StText(
                                                  " -",
                                                  weight: FontWeight.w500,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              transform:
                                                  Matrix4.translationValues(
                                                      0, 2, 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: primaryColor),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 6),
                                              child: StText(
                                                "${listeners[index].gender.toString()[0].toUpperCase()} - ${listeners[index].age}Y",
                                                weight: FontWeight.bold,
                                                size: 11,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
