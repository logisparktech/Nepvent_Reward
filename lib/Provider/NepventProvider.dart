import 'package:flutter/material.dart';

class NepventProvider with ChangeNotifier {
  String _profileImageUrl = '';

  String get profileImageUrl => _profileImageUrl;

  void setProfileImageUrl(String url) {
    _profileImageUrl = url;
    notifyListeners();
  }
}
