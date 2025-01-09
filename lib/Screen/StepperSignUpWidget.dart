import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/Design/CustomPasswordTextFormField.dart';
import 'package:nepvent_reward/Screen/Design/CustomTextFormField.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Screen/showPrivacyPolicy.dart';
import 'package:nepvent_reward/Screen/showTermsAndConditions.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class StepperSignUpWidget extends StatefulWidget {
  const StepperSignUpWidget({super.key});

  @override
  State<StepperSignUpWidget> createState() => _StepperSignUpWidgetState();
}

class _StepperSignUpWidgetState extends State<StepperSignUpWidget> {
  int _currentStep = 0;
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    conPasswordController.dispose();
  }

  _validateEmails(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    } else {
      return '';
    }
  }

  _validatePhoneNumbers(String value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^9\d{9}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit number starting with 9';
    } else {
      return '';
    }
  }

  _submit() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    try {
      final Response response = await dio.post(
        urls['register']!,
        data: {
          "fullName": name,
          "email": email,
          "phone": phone,
          "password": password,
        },
      );
      debugPrint(response.statusMessage);
      if (response.statusCode == 201) {
        var token = response.data['data']['token'];
        await secureStorage.write(key: 'token', value: token);
        await secureStorage.write(
            key: 'userID',
            value: response.data['data']['user']['_id'].toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginDashboardWidget(
              tabIndex: 0,
              profileUrl: '',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFFD50032),
            content: Text('Please check your internet connection.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFFD50032),
          content: Text(e.response?.data['message']['reason'] ??
              'Please check your internet connection.'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (error) {
      debugPrint("Error ON Login : $error");
    }
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep == 0 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 0,
          title: const Text('Name'),
          content: nameContainer(),
        ),
        Step(
          state: _currentStep == 1
              ? StepState.editing
              : _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Information'),
          content: infoContainer(),
        ),
        Step(
          state: _currentStep == 2 ? StepState.editing : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text('Password'),
          content: passwordContainer(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        title: Text(
          'Sign Up',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ), // Leading icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: const Color(0xFFDD143D),
                    // Color for active and completed steps
                    onSurface: Colors.grey, // Color for inactive steps
                  ),
                ),
                child: SizedBox(
                  height: screen.height * 0.90,
                  // color: Colors.greenAccent,
                  child: Stepper(
                    // margin: EdgeInsets.zero,
                    type: StepperType.vertical,
                    steps: getSteps(),
                    currentStep: _currentStep,
                    onStepContinue: () async {
                      final isLastStep = _currentStep == getSteps().length - 1;

                      if (isLastStep) {
                        if (passwordController.text.isNotEmpty &&
                            passwordController.text.length >= 6) {
                          if (conPasswordController.text ==
                              passwordController.text) {
                            _submit();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFFD50032),
                                content: Text('Passwords do not match'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFFD50032),
                              content: Text(
                                  'Please enter a password (at least 6 characters long).'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } else if (_currentStep == 0) {
                        if (nameController.text.isNotEmpty) {
                          if (_agreedToTerms) {
                            if (_agreedToPrivacy) {
                              setState(() => _currentStep++);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xFFD50032),
                                  content: Text('Please check Privacy Policy.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFFD50032),
                                content:
                                    Text('Please check Terms and Conditions.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFFD50032),
                              content: Text('Please Enter Your Name.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      } else if (_currentStep == 1) {
                        final email =
                            await _validateEmails(emailController.text);
                        final phone =
                            await _validatePhoneNumbers(phoneController.text);

                        if (email.isEmpty) {
                          if (phone.isEmpty) {
                            setState(() => _currentStep++);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFFD50032),
                                content: Text(phone),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFFD50032),
                              content: Text(email),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    onStepCancel: _currentStep == 0
                        ? null
                        : () => setState(() => _currentStep--),
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_currentStep > 0)
                              ElevatedButton(
                                onPressed: details.onStepCancel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFDD143D),
                                  // Background color
                                  foregroundColor: Colors.white,
                                  // Text color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                // Background color
                                foregroundColor: Colors.white,
                                // Text color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                _currentStep == getSteps().length - 1
                                    ? 'Finish'
                                    : 'Next',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // _currentStep == 0 ?
            ],
          ),
        ),
      ),
    );
  }

  Container passwordContainer() => Container(
        padding: const EdgeInsets.all(16.0), // Adds space around the container
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: Offset(0, 4), // Shadow offset
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align text and fields to the left
          children: [
            Text(
              'Kindly provide your security key to proceed.',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0), // Space between text and form fields

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomPasswordTextFormField(
                controller: passwordController,
                hintText: 'Password',
                labelText: 'Password',
                isPassword: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomPasswordTextFormField(
                controller: conPasswordController,
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
                isPassword: false,
                password: passwordController,
              ),
            ),
          ],
        ),
      );

  Container infoContainer() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        // Add padding around the container
        decoration: BoxDecoration(
          color: Colors.white, // Set background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Subtle shadow
              blurRadius: 10,
              offset: Offset(0, 4), // Shadow direction
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${nameController.text}, ', // The name part
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDD143D), // Highlighted name color
                    ),
                  ),
                  TextSpan(
                    text: 'Can you tell us more about yourself?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Regular text color
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Space between text and input fields
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextFormField(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                type: 'email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextFormField(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: phoneController,
                keyboardType: TextInputType.number,
                type: 'phone_number',
              ),
            ),
          ],
        ),
      );

  Container nameContainer() => Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 16),
              child: Text(
                'Can you introduce yourself ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              controller: nameController,
              keyboardType: TextInputType.name,
              type: 'name',
            ),
            // const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () => showTermsAndConditions(context),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black, // Default text color
                              ),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDD143D),
                                // Highlighted text color
                                decoration: TextDecoration
                                    .none, // Underlined to emphasize
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToPrivacy,
                      onChanged: (value) {
                        setState(() {
                          _agreedToPrivacy = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () => showPrivacyPolicy(context),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black, // Default text color
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFDD143D),
                                // Highlighted text color
                                decoration: TextDecoration
                                    .none, // Underlined to emphasize
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}
