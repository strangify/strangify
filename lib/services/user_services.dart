// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:strangify/models/user_model.dart' as suser;
import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/screens/home_screen.dart';
import '../constants.dart';
import '../helpers/methods.dart';
import '../screens/listener_home.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final CollectionReference _ref =
  //     FirebaseFirestore.instance.collection("users");

  Future<suser.User?> getUserDetails() async {
    User user = _auth.currentUser!;
    try {
      DocumentSnapshot userSnap =
          await _db.collection('users').doc(user.uid).get();
      suser.User dbUser =
          suser.User.fromSnap(userSnap.data() as Map<String, dynamic>);

      return dbUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInWithPhoneNumber(
      String phoneNumber,
      String otp,
      String verificationId,
      BuildContext context,
      UserProvider provider) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        DocumentSnapshot userSnap =
            await _db.collection('users').doc(user.uid).get();
        bool userExists = userSnap.exists;
        if (userExists) {
          //    suser.User.fromSnap(userSnap.data() as Map<String, dynamic>);
          provider.refreshUser().then((value) => Navigator.of(context)
              .pushReplacementNamed(value?.role == 'speaker'
                  ? HomeScreen.routeName
                  : ListenerHomeScreen.routeName));
        } else {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await _db.collection('users').doc(user.uid).set({
              "deviceToken": prefs.getString(deviceToken),
              "role": "speaker",
              "recentlyConnected": [],
              "uid": user.uid,
              "phone": phoneNumber,
              "walletBalance": 0.0
            }).then((value) => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName));
          } catch (e) {
            showSnack(
                context: context,
                message: "Something went wrong, Try again later.",
                color: Colors.red);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        showSnack(
            context: context,
            message: 'The verfication code provided not correct.',
            color: Colors.red);
      } else if (e.code == 'invalid-verification-id') {
        showSnack(
            context: context,
            message: 'The verfication id provided not correct.',
            color: Colors.red);
      } else {
        showSnack(
            context: context,
            message: "Something went wrong, Try again later.",
            color: Colors.red);
      }
    } catch (e) {
      showSnack(
          context: context,
          message: "Something went wrong, Try again later.",
          color: Colors.red);
    }
  }

  Future<bool> convertToListener(
      {required String role,
      required String name,
      required String email,
      required String gender,
      required String age,
      required String description,
      required XFile image,
      required List selectedTags,
      required List languages,
      required bool isChatEnabled,
      required bool isCallEnabled}) async {
    try {
      String url = await uploadProfileImage(
          File(image.path), "$role/${_auth.currentUser!.uid}");
      _db.collection("users").doc(_auth.currentUser!.uid).update({
        "role": "$role-pending",
        "name": name,
        "email": email,
        "isOnline": false,
        "gender": gender,
        "age": age,
        "description": description,
        "imageUrl": url,
        "reviews": [],
        "tags": selectedTags,
        "languages": languages,
        "toNotifyTokens": [],
        "isChatEnabled": isChatEnabled,
        "isCallEnabled": isCallEnabled,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
