import 'package:flutter/material.dart';

class NepventProvider with ChangeNotifier {
  String? _vendor;

  String? get vendor => _vendor;

  void setVendor(String vendor) {
    _vendor = vendor;
    notifyListeners();
  }
  // String? _vendorId;
  //
  // String? get vendorId => _vendorId;
  //
  // void setVendorId(String vendor) {
  //   _vendorId = vendor;
  //   notifyListeners();
  // }
}
