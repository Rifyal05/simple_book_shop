import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = 'User';

  String get username => _username;

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }
}