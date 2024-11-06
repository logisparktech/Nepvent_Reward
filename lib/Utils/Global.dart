import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepvent_reward/Model/NotificationModel.dart';
import 'package:nepvent_reward/Model/VendorDetailModel.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// DIO
  var dio = Dio();

const secureStorage = FlutterSecureStorage();
List<NotificationModel> notificationModel = [];

List<VendorDetailModel> vendorDetailModel = [];


