import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:strangify/providers/user_provider.dart';

import '../constants.dart';
import '../helpers/methods.dart';

TextEditingController messageController = TextEditingController();
XFile? file;

supportEmailDialog(BuildContext context) async {
  UserProvider userP = Provider.of<UserProvider>(context);
  bool isLoading = false;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, ss) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Support Email',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Please share your queries with us'),
                  const SizedBox(height: 15),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Message cannot be empty';
                      }
                    },
                    controller: messageController,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Message*",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: (() async {
                            file = await getImageFromGallery();
                            ss(() {});
                          }),
                          child: const Text(
                            'Add Image',
                            style: TextStyle(color: primaryColor),
                          )),
                      ElevatedButton(
                          child: isLoading
                              ? const SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ))
                              : const Text("Submit"),
                          onPressed: () async {
                            if (messageController.text.isEmpty) {
                              return;
                            }
                            ss(() {
                              isLoading = true;
                            });
                            String url = "";
                            if (file != null) {
                              url = await uploadProfileImage(
                                  File(file!.path), "/support");
                            }
                            FirebaseFirestore.instance
                                .collection("support")
                                .doc()
                                .set({
                              "title": messageController.text,
                              "userId": userP.getUser!.uid,
                              "imageUrl": url
                            }).then((value) => Navigator.of(context).pop());
                          }),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      });
}
