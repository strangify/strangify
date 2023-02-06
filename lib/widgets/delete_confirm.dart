import 'package:flutter/material.dart';

import 'st_text.dart';

void endSessionDialog(
    BuildContext context, String deleteType, void Function() func) {
  showDialog(
      context: context,
      builder: (builder) {
        return Dialog(
            child: SizedBox(
          width: 340,
          height: 210,
          child: Card(
              elevation: 4,
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const StText(
                            "Are you Sure?",
                            size: 24,
                          ),
                          StText("Do you wish to end the $deleteType?",
                              color: Colors.grey[800]),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFF080808))),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 2),
                                    child: StText(
                                      "Cancel",
                                      color: Colors.white,
                                      size: 16,
                                      weight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red)),
                                    onPressed: func,
                                    child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 2),
                                        child: StText(
                                          "End",
                                          color: Colors.white,
                                          size: 16,
                                          weight: FontWeight.w100,
                                        ))),
                              ],
                            ),
                          )
                        ],
                      )),
                  Positioned(
                      right: 16,
                      top: 12,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close)))
                ],
              )),
        ));
      });
}
