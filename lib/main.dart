import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nepvent_reward/Check.dart';
import 'package:nepvent_reward/Helper/AuthInterceptor.dart';
import 'package:nepvent_reward/Provider/NepventProvider.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  dio.options.baseUrl = dotenv.env['API_URL']!;
  dio.interceptors.add(AuthInterceptor());

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NepventProvider>(
          create: (context) => NepventProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Check(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
