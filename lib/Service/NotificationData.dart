import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:path_provider/path_provider.dart';

class NotificationData {
  show(String title, String message, date, imageUrl) async {
    if (message.isNotEmpty && title.isNotEmpty) {
      BigPictureStyleInformation? bigPictureStyleInformation;
      String? localImagePath ;

      if (imageUrl.isNotEmpty) {
        localImagePath =
            await _downloadAndSaveImage(imageUrl, 'notification_image.png');
      }

      if (localImagePath != null) {
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(localImagePath), // Path to the downloaded image
          contentTitle: title,
          summaryText: message,
        );
      }
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Nepvent Loyalty',
        'Nepvent Loyalty',
        playSound: true,
        ticker: 'ticker',
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true,
        styleInformation: bigPictureStyleInformation,
        largeIcon:localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await FlutterLocalNotificationsPlugin().show(
        0,
        title,
        message,
        platformChannelSpecifics,
      );
    } else {
      debugPrint('Message And Title is Empty or null');
    }
    debugPrint(' Notification Message : $message');
    debugPrint(' Notification image : $imageUrl');
  }

  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      return filePath;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }
}
