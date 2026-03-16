import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _enableAi = true;

  bool get enableAi => _enableAi;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _enableAi = prefs.getBool('enable_ai') ?? true;
    notifyListeners();
  }

  Future<void> toggleAi(bool value) async {
    _enableAi = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_ai', value);
    notifyListeners();
  }
}
