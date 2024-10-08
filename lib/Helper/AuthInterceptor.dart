import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    try {
      if (err.response != null) {
        BuildContext? c = navigatorKey.currentContext;
        // Unauthorised / token expired
        if (err.response?.statusCode == 401) {
          String? message;
          if (err.response?.data != null) {
            if (err.response?.data.runtimeType == String) {
              message = 'Session Expired. Please Sign-in Again';
            } else {
              message = err.response?.data['message'];
            }
          } else {
            message = null;
          }
          // Navigator.pushReplacement(
          //     c!,
          //     MaterialPageRoute(
          //       builder: (c) => const LogInWidget(),
          //     ));
        } else if (err.response?.statusCode == 404) {
          String? message;
          if (err.response?.data != null) {
            if (err.response?.data.runtimeType == String) {
              message = 'Url not Found';
            } else {
              message = err.response?.data['message'].toString();
            }
          } else {
            message = null;
          }
          return handler.next(err);
          // Navigator.pushReplacement(
          //     c!,
          //     MaterialPageRoute(
          //       builder: (c) => message != null ? const LoginWidget() : const LoginWidget(),
          //     ));
        } else if (err.response?.statusCode == 400) {
          String? message;
          if (err.response?.data != null) {
            if (err.response?.data.runtimeType == String) {
              message = 'Bad Request';
            } else {
              message = err.response?.data['message'].toString();
            }
          } else {
            message = null;
          }
          return handler.next(err);
        } else {
          return handler.next(err);
        }
        // Tenant disabled
        // if (e.response?.statusCode == 402) {
        //   Navigator.pushReplacement(
        //       c!,
        //       MaterialPageRoute(
        //         builder: (c) => const DisabledWidget(),
        //       ));
        // }
        // else {
        //   handler.next(e);
        // }
      } else {
        print(' ** This is Coming from Auth Interceptor ** : $err');
        return handler.next(err);
      }
    } catch (error) {
      print('** AuthInterceptor catch error ** :   $error');
    }
  }
}
