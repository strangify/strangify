import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF5474fb);
const Color primaryLight = Color.fromARGB(255, 179, 192, 249);
const Color greyColor = Color.fromRGBO(97, 97, 97, 1);
const String deviceToken = "DEVICE_TOKEN";

InputBorder border = const UnderlineInputBorder(
  borderSide: BorderSide(color: primaryColor, width: 2),
);
InputBorder errorBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.red, width: 2),
  borderRadius: BorderRadius.circular(0),
);

InputDecoration getTfDecortion(String title) {
  return InputDecoration(
      border: border,
      errorBorder: errorBorder,
      disabledBorder: border,
      focusedErrorBorder: errorBorder,
      enabledBorder: border,
      focusedBorder: border,
      hintText: title,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        height: 1,
        fontSize: 16,
      ));
}

const List<Map<String, dynamic>> onboardingElements = [
  {
    "title": "Feeling Low?\nWe have something for you !",
    "image": "assets/onboarding-1.jpg"
  },
  {
    "title": "Connect with listener of your choice",
    "image": "assets/onboarding-2.jpg"
  },
  {"title": "Vent your heart out", "image": "assets/onboarding-3.jpg"}
];

const List interestList = [
  {"name": "Depression", "desc": "Fight your negative thoughts and anxiety."},
  {"name": "Loneliness", "desc": "Have someone to talk to right away."},
  {"name": "Family Issues", "desc": ""},
  {"name": "Office Issues", "desc": ""},
];
