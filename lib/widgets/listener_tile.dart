import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ListenerTile extends StatelessWidget {
  final User user;

  const ListenerTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .16),
            offset: Offset(0, 3),
            blurRadius: 5)
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: user.imageUrl == null
                  ? const Text('No Image')
                  : Image.network(
                      user.imageUrl!,
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                      errorBuilder: (context, exception, stackTrace) {
                        return Container(
                          height: 80,
                          width: 80,
                          child: const Center(
                            child: Text('No Image'),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2, right: 8),
                        child: Text(user.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              color: Color.fromRGBO(6, 55, 99, 1),
                            )),
                      ),
                    ),
                    // displableList![index!]['host'] == null
                    //     ? const SizedBox()
                    //     : displableList![index!]['host']['isPremium']
                    //         ? Container(
                    //             transform: Matrix4.translationValues(0, -3, 0),
                    //             child: Image.asset(
                    //               'assets/icons/Premium-Host.png',
                    //               height: 25,
                    //             ),
                    //           )
                    //         : const SizedBox(
                    //             width: 4,
                    //           ),
                  ],
                ),
                Text(user.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, height: 1.2, color: Color(0xFF9FA8B0))),
                const SizedBox(
                  height: 5,
                ),
                Text("",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, height: 1.2, color: Color(0xFF2A5277))),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 18,
              ),
              child: const SizedBox(
                width: 40,
              ))
        ],
      ),
    );
  }
}
