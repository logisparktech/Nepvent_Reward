import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/SignUpWidget.dart';

class LoginForWebWidget extends StatefulWidget {
  const LoginForWebWidget({super.key});

  @override
  State<LoginForWebWidget> createState() => _LoginForWebWidgetState();
}

class _LoginForWebWidgetState extends State<LoginForWebWidget> {
  bool isLoading = false;

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
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.person, color: Colors.black, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Phone Number Input
                    const SizedBox(
                      width: double.infinity, // Constrain width
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password Input
                    const SizedBox(
                      width: double.infinity, // Constrain width
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (newValue) {
                            // Handle checkbox change
                          },
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Login Button
              
                    ElevatedButton(
                      onPressed: () async {
                        // if (_formKey.currentState!
                        //     .validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        // Call the login function (or any async operation)
                        // await _login();

                        setState(() {
                          isLoading = false;
                        });
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD50032),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
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
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
              
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account yet? ",
                        style: TextStyle(color: Colors.grey[800]),
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
                                    builder: (context) => const SignUpWidget(),
                                  ),
                                );
                              },
                          ),
                          TextSpan(
                            text: " here.",
                            style: TextStyle(color: Colors.grey[800]),
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
      ),
    );
  }
}
