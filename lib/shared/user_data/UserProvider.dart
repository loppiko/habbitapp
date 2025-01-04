import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  double? _experience;
  double? _money;

  String? get username => _username;
  double? get experience => _experience;
  double? get money => _money;

  set username(String? username) {
    _username = username;
    notifyListeners();
  }

  set experience(double? experience) {
    _experience = experience;
    notifyListeners();
  }

  set money(double? money) {
    _money = money;
    notifyListeners();
  }

  void clearUser() {
    _username = null;
    notifyListeners();
  }
}
