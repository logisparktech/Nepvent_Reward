import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Check.dart';
import 'package:nepvent_reward/Screen/Design/CustomPasswordTextFormField.dart';
import 'package:nepvent_reward/Screen/Design/CustomTextFormField.dart';
import 'package:nepvent_reward/Screen/Web/SignUpForWeb.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForWebWidget extends StatefulWidget {
  const LoginForWebWidget({super.key});

  @override
  State<LoginForWebWidget> createState() => _LoginForWebWidgetState();
}

class _LoginForWebWidgetState extends State<LoginForWebWidget> {
  bool isLoading = false;
  bool remamberMe = false;

  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = true;
    _loadSavedData();
  }

  _login() async {
    String number = numberController.text.trim();
    String password = passwordController.text.trim();
    try {
      final Response response = await dio.post(
        urls['login']!,
        data: {
          "phoneNumber": number,
          "password": password,
        },
      );
      debugPrint(response.statusMessage);
      if (response.statusCode == 201) {
        var token = response.data['data']['token'];

        await secureStorage.write(
          key: 'token',
          value: token,
        );
        await secureStorage.write(
          key: 'userID',
          value: response.data['data']['id'].toString(),
        );
        if (response.data['data']?.containsKey('displayPicture') == true &&
            response.data['data']['displayPicture']?.containsKey('url') ==
                true) {
          await secureStorage.write(
            key: 'ProfilePic',
            value: response.data['data']['displayPicture']['url'].toString(),
          );
        }
        await _saveData();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Check(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFFD50032),
            content: Text('Please check your internet connection.'),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFD50032),
          content: Text(e.response?.data['message']['reason'] ??
              'Please check your internet connection.'),
        ),
      );
    } catch (error) {
      debugPrint("Error ON Login : $error");
    }
  }
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNumber = prefs.getString('number');
    String? savedPassword = prefs.getString('password');
    bool? rememberMe = prefs.getBool('rememberMe');

    if (savedNumber != null && savedPassword != null && rememberMe == true) {
      setState(() {
        numberController.text = savedNumber;
        passwordController.text = savedPassword;
        remamberMe = rememberMe!;
      });
    }
  }
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (remamberMe) {
      await prefs.setString('number', numberController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberMe', remamberMe);
    } else {
      await prefs.remove('number');
      await prefs.remove('password');
      await prefs.remove('rememberMe');
    }
  }

  @override
  void dispose() {
    super.dispose();
    numberController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 16,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800,
        height: 450,
        // padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0), // Top-left corner radius
                bottomLeft: Radius.circular(10.0), // Bottom-left corner radius
              ), // Set your desired radius
              child: Image.asset(
                'assets/images/top-view.jpg', // Promo Image for offer
                fit: BoxFit.cover,
                width: 400,
                height: 450,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            MdiIcons.closeCircleOutline,
                            color: Color(0xFFD50032),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Icon(
                          MdiIcons.account,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 5, 10, 5),
                              child: CustomTextFormField(
                                labelText: 'Phone Number',
                                hintText: 'Phone Number',
                                keyboardType: TextInputType.number,
                                controller: numberController,
                                type: 'phone_number',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 5, 10, 5),
                              child: CustomPasswordTextFormField(
                                controller: passwordController,
                                hintText: 'Password',
                                labelText: 'Password',
                                isPassword: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Remember Me Checkbox
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0, left: 10, right: 10),
                      child: Row(
                        children: [
                          Checkbox(
                            value: remamberMe,
                            activeColor: Color(0xFFD50032),
                            onChanged: (newValue) {
                              // Handle checkbox change
                              setState(() {
                                remamberMe = newValue!;
                              });
                            },
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(top: 14.0, left: 10, right: 10),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await _login();
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD50032),
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 0),
                            minimumSize: Size(screen.width, 60),
                            elevation: 2,
                            side: const BorderSide(
                              color: Color(0xFFD50032),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account yet? ",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: ' Register ',
                              style: TextStyle(
                                color: const Color(0xFFD50032),
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // handle the link tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpForWeb(),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: " here.",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
