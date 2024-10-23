import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Check.dart';
import 'package:nepvent_reward/Screen/Web/SignUpForWeb.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

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
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _isObscured = true;
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

  @override
  void dispose() {
    _unfocusNode.dispose();
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
        width: screen.width / 2,
        height: screen.height / 2,
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
                fit: BoxFit.fill,
                width: screen.height / 2,
                height: screen.height / 2,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFD50032),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
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
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: TextFormField(
                                controller: numberController,
                                autofocus: false,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD50032),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    // Optional: Keep same design for error
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      // Keep the same color as enabled border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    // Optional: Keep same design for focused error
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      // Keep the same color as focused border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorStyle: const TextStyle(
                                    // Style for the error message
                                    color: Color(0xFFD50032),
                                    // Change color to red for error message
                                    fontSize: 12, // Adjust font size as needed
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                                onChanged: (input) {
                                  _formKey.currentState!.validate();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (!RegExp(r'^9\d{9}$').hasMatch(value)) {
                                    return 'Please enter a valid 10-digit number starting with 9';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: TextFormField(
                                controller: passwordController,
                                autofocus: false,
                                obscureText: _isObscured,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD50032),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    // Optional: Keep same design for error
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      // Keep the same color as enabled border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    // Optional: Keep same design for focused error
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      // Keep the same color as focused border
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorStyle: const TextStyle(
                                    // Style for the error message
                                    color: Color(0xFFD50032),
                                    // Change color to red for error message
                                    fontSize: 12, // Adjust font size as needed
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(
                                        () => _isObscured = !_isObscured),
                                    child: Icon(
                                      _isObscured
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Color(0xFFD50032),
                                      size: 22,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                onChanged: (input) {
                                  _formKey.currentState!.validate();
                                },
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
                          const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                      child: SizedBox(
                        height: 45,
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
                            minimumSize: Size(screen.width, 40),
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
