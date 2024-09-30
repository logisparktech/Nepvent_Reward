import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Global {

  BaseOptions options = BaseOptions(
    baseUrl: dotenv.env['API_URL']!,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 90), // Use Duration for better readability
  );



  // DIO
  // var dio = Dio(options);
}