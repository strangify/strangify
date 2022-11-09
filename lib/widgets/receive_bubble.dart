import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ReceiveBubble extends StatelessWidget {
  final String message;
  final bool isLastByUser;
  final DateTime dateTime;

  const ReceiveBubble({
    Key? key,
    required this.message,
    required this.isLastByUser,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(right: 100, left: 16, top: 2, bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE9EDF1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: Color.fromRGBO(6, 55, 99, 1),
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
              isLastByUser
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        //dateTime.substring(11, 16),
                        DateFormat("hh:mm a").format(dateTime),
                        style: const TextStyle(
                            color: Color(0xFF707070),
                            fontWeight: FontWeight.w500,
                            fontSize: 10),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
