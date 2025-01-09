import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: implement onRequest
    print('** Request Form AuthInterceptor **: ${options.uri}');
    try {
      //Define here url who don't require JWT Token
      final listOfPaths = <String>[
        urls['banner']!,
        urls['limitVendor']!,
        urls['vendor']!,
        urls['AllVendor']!,
        urls['login']!,
        urls['register']!,
      ];
      // Check if the requested endpoint match in the
      if (listOfPaths.contains(options.path.toString())) {
        // if the endpoint is matched then skip adding the token.
        return handler.next(options);
      }

      String token = await secureStorage.read(key: 'token') ?? '';
        debugPrint(' ****** 😍Token😶‍🌫️ ***** : $token ');
      // Load your token here and pass to the header
      options.headers.addAll({'Authorization': 'Bearer $token'});

      return handler.next(options);
    } on PlatformException catch (error) {
      await secureStorage.deleteAll();
      debugPrint(
          "Platform Exception Error Message From AuthInterceptor $error");
    } catch (err) {
      debugPrint("Error Message From AuthInterceptor $err");
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // TODO: implement onResponse

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response != null) {
        BuildContext? context = navigatorKey.currentContext;

        if (err.response?.statusCode == 401) {
          String? message;

          // Determine the error message
          if (err.response?.data != null) {
            if (err.response?.data.runtimeType == String) {
              message = 'Session Expired. Please Sign-in Again.';
            } else {
              message = err.response?.data['message'];
            }
          } else {
            message = 'Session Expired. Please Sign-in Again.';
          }

          // Clear token
          await secureStorage.delete(key: 'token');

          // Show message (optional)
          if (context != null) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(message ?? 'Session expired.')),
            // );

            // Navigate to the login page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardWidget()),
              (route) => false, // Remove all previous routes
            );
          }
        } else {
          return handler.next(err); // Pass other errors to the handler
        }
      } else {
        debugPrint(' ** This is Coming from Auth Interceptor ** : $err');
        return handler.next(err);
      }
    } catch (error) {
      debugPrint('** AuthInterceptor catch error ** : $error');
      return handler.next(err);
    }
  }
}
