import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

//const sessionExpiryDuration = 12000;
// const fakeListenerPrice = 10;
// const listenerPrice = 7;
// const fakeCounsellorPrice = 20;
// const counsellorPrice = 10;
Worksheet? worksheet;

const String gsheetCredentials = r'''
{
  "type": "service_account",
  "project_id": "strangify-b369f",
  "private_key_id": "ccf290b02017a4f703ea7302a648a98a1e8749de",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC3Ef1z8xL6c4wR\nA6qCIStQAGB90ZzS5SBz6VobGWbv12iGMwF6gxPEfqyVqPiULIEQ78S2wYdJGd0C\nRRQplKndCojyeGvyudm3SbCXcZ7BEFgHyCFteYjLtj3xz/ZYmtjZ6Jsddg9Mvbvp\n6AVHytfsppFJSF8tcCfUFFdbF9woy9nlBnCqVEHD3MMwRPKE/C5eZbCUNs8o5++1\n/sGPxBYCI6kPgfuJqMGnyCPfzPE43ykmZJQtml1hRQbXox1ToZbPAUeajuuuvEfd\nSPY3ikKdxcvkLMq296MYy4flsXaKCaK1QtmuNb7QYefoU+iJbOy7YIf6Ghk6j6k6\nPIznE7bnAgMBAAECggEAOSWqgsl8QSZUsPL+BQUpqh2UAXKvi73utYBAmnkBgxkx\nDcNaUM4eG5aXdVh70HVcDNdsBsi+3HjwXscFlj1MES46tcYVnH2bkvWz5HKZZhce\nA7/bf3sS0tSe3Z9XfS1JSCyuTzINcJ1BzbCaBWEyqjMM411uKJb8N93prwvxs+H3\nP58X4Kxl/HTFYZjmM7ZAxYzdbtpVcZpi+jzYftWC8+fjJrwDw3dEMvPkX9wayx8c\nCLvdkw3vHaxQ9suiz4K5KTF0yvSH4jJEUL6Emg5ecq8OCPFyXZlD/wBfElqGLqBh\nJCMejMEDHeRhg734f+unKgFIV5gf1zjiqkBEMsjssQKBgQDm/VU0MR8bFHu1eCQB\nrm2RTdNObPZ1Xmj0KlqPnSTYGGxmjRZ/l2Lu8HZTo+mlqSIfamfpVrEISf3F32qG\nqeGaY0lQ47ky7fdZQVeghS/PpVumJN0OhwJwnO/CyrVq/VGeIizqFaSm+SSTBeil\n8oigcBX3UG/WhJcbhh/5aUQGUwKBgQDK5GjW96PWNoPK/jNQIgHoBdCWg1psz+3R\nxI4DGfbWrzFHFOM7SI10SXNOzEl4xQwCJzQSsIa/1ePjmv0Hi4X3HbokKGpSIjjZ\npiSsTrvykbxNPWDctY5RFp7A5E5NQYGJiTJiBT0t+m8Eck4TY9ws/WCCYu7qmW5h\nqsPTPy4SnQKBgE0imdpU8Ps9CtadqQB6vBICuCZ/Uon9HfUzU4yTwGL9PO29/Z5b\n8miyGgFyQirU4RU2lj6geXu4Iat7IPqZLkI9F5WQhh7QwoGmxVlQQJgJsyI3Oy6H\nvTPX5GTbBlwU/bVd2jvNQG+V0TXbikYoSKGy7FLrJH2xRzikwHasRVALAoGAUOwW\n8J5mxzqJCD6pAq39qqgfENklCL9J8F9/8La7X9cSRXKMSwnd+WKOTgBm0XduGbG/\nMDEeHYdW1GHtx8ObU/uUUXWZKlch65U7jUn95nq/6uKvLnhvYeIuwWqN3HxjCRMi\neDv0sdDv1Isunsc2eu84Pejtt74oa2XroubRHnUCgYBOdVn3me1tCmtXknx21RVv\nwmzfHL2ZolRh1aexCzqlw0xl8Srl04U7MgDGGL2+MM0zhwsyoXlcWWqpGELXQtGe\nasNhOdUJfRGvd1mFOl/5rrcwwuos/Bcl45c9IlaOp98azg5cJsbSRkkDZq0SnFZ/\nWpguI2r7r/Tt1jVuw960SQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheetstrangify@strangify-b369f.iam.gserviceaccount.com",
  "client_id": "114213690205543559983",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheetstrangify%40strangify-b369f.iam.gserviceaccount.com"
}
''';

const Color primaryColor = Color(0xFF5474fb);
const Color primaryLight = Color.fromARGB(255, 179, 192, 249);
const Color gradient1 = Color(0xFF3341af);
const Color gradient2 = Color(0xFF5170fd);

const Color greyColor = Color.fromRGBO(97, 97, 97, 1);
const String deviceToken = "DEVICE_TOKEN";

InputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: gradient1, width: 1),
    borderRadius: BorderRadius.circular(5));
InputBorder walletBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: gradient1, width: 1.5),
);
InputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 1),
    borderRadius: BorderRadius.circular(5));

InputDecoration getTfDecortion(String title) {
  return InputDecoration(
      border: border,
      errorBorder: errorBorder,
      disabledBorder: border,
      isDense: true,
      focusedErrorBorder: errorBorder,
      enabledBorder: border,
      focusedBorder: border,
      hintText: title,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        height: 1,
        fontSize: 14,
      ));
}

const List<Map<String, dynamic>> onboardingElements = [
  {"title": "Feeling Low?", "image": "assets/onboarding-1.png"},
  {
    "title": "Connect with listener of your choice",
    "image": "assets/onboarding-2.png"
  },
  {"title": "Vent your heart out", "image": "assets/onboarding-3.png"}
];

const List interestList = [
  {
    "name": "Relationship",
    "desc": "Suffering, Misunderstanding & Miscommunication"
  },
  {"name": "Loneliness", "desc": "Tired of voids, Need someone to talk to?"},
  {"name": "Friendship", "desc": "Trust issues, unnecessary possessiveness"},
  {"name": "Stress", "desc": "Feel calm, Distressed with us"},
  {"name": "Career", "desc": "Deadlines, Tired of procrastination"},
  {"name": "Studies", "desc": "Lack of focus, need guidance?"},
  {"name": "Breakup", "desc": "Heartache, Forbidden love!"},
  {"name": "Office", "desc": "Day to Day Office Issues."},
];
