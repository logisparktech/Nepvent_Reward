import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// DIO
  var dio = Dio();

const secureStorage = FlutterSecureStorage();
