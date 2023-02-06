import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../widgets/st_text.dart';

showSnack(
    {required BuildContext context,
    required String message,
    Color? color,
    double? margin}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: margin ?? 30, left: 20, right: 20),
    content: StText(
      message,
      size: 14,
      color: Colors.white,
    ),
    backgroundColor: color ?? const Color(0xFF080808),
  ));
}

Future getImageFromCamera() async {
  var image = await ImagePicker().pickImage(source: ImageSource.camera);
  return image;
}

Future getImageFromGallery() async {
  var image = await ImagePicker().pickImage(source: ImageSource.gallery);
  return image;
}

Future<String> uploadProfileImage(File file, String path) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  try {
    var task = await storage.ref().child(path).putFile(file);
    return await task.ref.getDownloadURL();
  } on FirebaseException catch (error) {
    // ignore: avoid_print
    print(error);
  } catch (err) {
    // ignore: avoid_print
    print(err);
  }
  return '';
}

String formatNumber(num value) {
  var formatter = NumberFormat('#,##,##0.00');
  return formatter.format(value);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase().replaceAll("*", '')}";
  }
}
