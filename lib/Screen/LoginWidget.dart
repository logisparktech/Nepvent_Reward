import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Check.dart';
import 'package:nepvent_reward/Screen/SignUpWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

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

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, // Align to the start
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
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: double.maxFinite,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 10, 10, 10),
                                      child: TextFormField(
                                        controller: numberController,
                                        autofocus: false,
                                        obscureText: false,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Phone Number',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD50032),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            // Optional: Keep same design for error
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              // Keep the same color as enabled border
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            // Optional: Keep same design for focused error
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              // Keep the same color as focused border
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorStyle: const TextStyle(
                                            // Style for the error message
                                            color: Colors.red,
                                            // Change color to red for error message
                                            fontSize:
                                                12, // Adjust font size as needed
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your phone number';
                                          }
                                          if (!RegExp(r'^9\d{9}$')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid 10-digit number starting with 9';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 10, 10, 10),
                                      child: TextFormField(
                                        controller: passwordController,
                                        autofocus: false,
                                        obscureText: _isObscured,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD50032),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            // Optional: Keep same design for error
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              // Keep the same color as enabled border
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            // Optional: Keep same design for focused error
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              // Keep the same color as focused border
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorStyle: const TextStyle(
                                            // Style for the error message
                                            color: Colors.red,
                                            // Change color to red for error message
                                            fontSize:
                                                12, // Adjust font size as needed
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(() =>
                                                _isObscured = !_isObscured),
                                            child: Icon(
                                              _isObscured
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: Color(0xFFD50032),
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password must be at least 6 characters long';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 15, 15, 5),
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
                                            ? const CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              )
                                            : const Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Don't have an account yet? ",
                                        style:
                                            TextStyle(color: Colors.grey[800]),
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
                                                        const SignUpWidget(),
                                                  ),
                                                );
                                              },
                                          ),
                                          TextSpan(
                                            text: " here.",
                                            style: TextStyle(
                                                color: Colors.grey[800]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
