import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

late GlobalKey<NavigatorState> navigatorKey  = GlobalKey<NavigatorState>();

  // BaseOptions options = BaseOptions(
  //   baseUrl: dotenv.env['API_URL']!,
  //   receiveDataWhenStatusError: true,
  //   connectTimeout: const Duration(seconds: 90), // Use Duration for better readability
  // );



  // DIO
  var dio = Dio();

const secureStorage = FlutterSecureStorage();
