import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Service/Socket.dart';
import 'package:nepvent_reward/Utils/Global.dart';



class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SocketService socketService = SocketService();
  String? token;
  String? userID;
  String? profilePic;

  @override
  initState() {
    super.initState();
    _getUserDetails().then((value) {
      if (value != null) {
        setState(() {
          var ipAddress ='http://192.168.1.154:4000/notification';
          token = value['token'];
          if (token != null && token != '') {
            print('socket connection hit');
            // print('token : $token');

            socketService.connectSocket(ipAddress,token);
          }
        });
      }
    });
  }

  Future<dynamic> _getUserDetails() async {
    try {
      token = await secureStorage.read(key: 'token') ?? '';
      userID = await secureStorage.read(key: 'userID') ?? '';
      profilePic = await secureStorage.read(key: 'ProfilePic') ??'';

      var object = {
        'token': token,
        'userID': userID,
        'ProfilePic': profilePic,
      };
      return object;
    } on PlatformException {
      await secureStorage.deleteAll();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            key: scaffoldKey,
            body: const CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Scaffold(
              key: scaffoldKey,
              body: const CircularProgressIndicator(),
            );
          } else {
            String token = snapshot.data['token'] ?? '';
            // String userID = snapshot.data['userID'] ?? '';
            String profileUrl = snapshot.data['ProfilePic'] ?? '';

            if (token.isEmpty) {
              return Scaffold(
                key: scaffoldKey,
                body: const DashboardWidget(),
              );
            } else {
              return Scaffold(
                key: scaffoldKey,
                body: LoginDashboardWidget(
                  tabIndex: 0,
                  profileUrl: profileUrl,
                ),
              );
            }
          }
        }
      },
    );
  }
}
