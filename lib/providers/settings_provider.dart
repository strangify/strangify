import 'package:flutter/material.dart';
import 'package:strangify/models/settings_model.dart';

import '../services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  SettingsModel? settings;
  SettingsModel? get getSettings => settings;

  Future<SettingsModel?> refreshUser() async {
    settings = await SettingService().getSettings();
    notifyListeners();
    return settings;
  }
}
