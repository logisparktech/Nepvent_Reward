import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Check.dart';
import 'package:nepvent_reward/Screen/Design/CustomPasswordTextFormField.dart';
import 'package:nepvent_reward/Screen/Design/CustomTextFormField.dart';
import 'package:nepvent_reward/Screen/SignUpWidget.dart';
import 'package:nepvent_reward/Screen/StepperSignUpWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  var _isObscured;
  bool isLoading = false;
  bool remamberMe = false;

  @override
  void initState() {
    super.initState();
    _isObscured = true;
    _loadSavedData();
  }

  @override
  void dispose() {
    super.dispose();
    _unfocusNode.dispose();
    numberController.dispose();
    passwordController.dispose();
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
          value: response.data['data']['_id'].toString(),
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
            backgroundColor: Color(0xFFD50032),
            content: Text('Please check your internet connection.'),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(builder: (context, constraints) {
        Size screen = MediaQuery.sizeOf(context);
        bool isMobile = screen.width < 700;
        bool isTablet = screen.width >= 700 && screen.width < 900;
        bool isWeb = screen.width >= 900;

        return Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/top-view.jpg',
                  fit: BoxFit.cover,
                  width: screen.width,
                  height: 300,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 300, // Same height as the image
                  color: Colors.red.withOpacity(0.5), // Color with transparency
                ),
              ),
              SafeArea(
                top: true,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft, // Align to the start
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: screen.height / 2,
                          constraints: const BoxConstraints(
                            maxWidth: double.maxFinite,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.person,
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
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: CustomTextFormField(
                                              labelText: 'Phone Number',
                                              hintText: 'Phone Number',
                                              keyboardType: TextInputType.number,
                                              controller: numberController,
                                              type: 'phone_number',
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10, 10, 10, 10),
                                          child: CustomPasswordTextFormField(
                                            controller: passwordController,
                                            hintText: 'Password',
                                            labelText: 'Password',
                                            isPassword: true,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, left: 10, right: 10),
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
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  15, 15, 15, 5),
                                          child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                    
                                                  // Call the login function (or any async operation)
                                                  await _login();
                                                    
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFD50032),
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(24, 0, 24, 0),
                                                minimumSize: Size(screen.width, 40),
                                                elevation: 2,
                                                side: const BorderSide(
                                                  color: Color(0xFFD50032),
                                                  width: 1,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: isLoading
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white),
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
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                                fontFamily: 'Poppins',
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: ' Register ',
                                                  style: TextStyle(
                                                    color: const Color(0xFFD50032),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      // handle the link tap
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const StepperSignUpWidget(),
                                                        ),
                                                      );
                                                    },
                                                ),
                                                TextSpan(
                                                  text: " here.",
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
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
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
