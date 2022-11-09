import 'package:flutter/material.dart';
import 'package:strangify/models/user_model.dart';
import 'package:strangify/services/user_services.dart';

class UserProvider with ChangeNotifier {
  User? user;
  User? get getUser => user;

  Future refreshUser() async {
    user = await UserService().getUserDetails();
    notifyListeners();
  }
}
