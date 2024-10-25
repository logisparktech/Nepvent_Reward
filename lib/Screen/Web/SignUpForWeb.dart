import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
import 'package:nepvent_reward/Screen/Design/CustomPasswordTextFormField.dart';
import 'package:nepvent_reward/Screen/Design/CustomTextFormField.dart';
import 'package:nepvent_reward/Screen/LoginDashboardWidget.dart';
import 'package:nepvent_reward/Utils/Enum.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class SignUpForWeb extends StatefulWidget {
  const SignUpForWeb({super.key});

  @override
  State<SignUpForWeb> createState() => _SignUpForWebState();
}

class _SignUpForWebState extends State<SignUpForWeb> {
  final _formKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final secPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();
  var _isObscured;
  String? _selectedProvince;
  String? _selectedDistrict;
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    secPhoneController.dispose();
    passwordController.dispose();
    conPasswordController.dispose();
  }

  _submit() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String secondNumber = secPhoneController.text.trim();
    String address = addressController.text.trim();
    try {
      final Response response = await dio.post(
        urls['register']!,
        data: {
          "fullName": name,
          "email": email,
          "phone": phone,
          "userDetail": {
            "address": address,
            "province": _selectedProvince,
            "district": _selectedDistrict,
            "secondaryNumber": secondNumber,
          },
          "password": password,
        },
      );
      debugPrint(response.statusMessage);
      if (response.statusCode == 201) {
        debugPrint('user ID : ${response.data['data']['user']['_id']}');
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
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardWidget(
                          tabIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/nepvent-red-logo.png',
                    // Path to your logo image
                    height: 100, // Set the height of the logo
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                        'Signup',
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
                  width: screen.width / 3,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomTextFormField(
                            labelText: 'Full Name',
                            hintText: 'Full Name',
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            type: 'name',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomTextFormField(
                            labelText: 'Email',
                            hintText: 'Email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            type: 'email',
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomPasswordTextFormField(
                            controller: conPasswordController,
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            isPassword: false,
                            password: passwordController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomTextFormField(
                            labelText: 'Phone Number',
                            hintText: 'Phone Number',
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            type: 'phone_number',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 20),
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFD2D7DE),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton(
                              value: _selectedProvince,
                              items: Province()
                                  .map(
                                    (province) => DropdownMenuItem(
                                      value: province,
                                      child: Text(
                                        province,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (dynamic value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedDistrict = null;
                                  _selectedProvince = value;
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xFFD50032),
                                fontSize: 16,
                              ),
                              hint: Text(
                                'Select the province',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFD50032),
                                size: 24,
                              ),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                              ),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 20),
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFD2D7DE),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton(
                              value: _selectedDistrict,
                              items: _selectedProvince != null
                                  ? getDistrictsByProvince(_selectedProvince!)
                                      .map((disct) {
                                      return DropdownMenuItem(
                                        value: disct,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            disct
                                                .toString()
                                                .replaceAll('District.', ''),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : getDistrictsByProvince(
                                          _selectedProvince ?? '')
                                      .map((dis) {
                                      return DropdownMenuItem(
                                        value: dis,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            dis,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              onChanged: (dynamic value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedDistrict = value;
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xFFD50032),
                                fontSize: 16,
                              ),
                              hint: Text(
                                'Select the district',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFD50032),
                                size: 24,
                              ),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                              ),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomTextFormField(
                            labelText: 'Address',
                            hintText: 'Address',
                            controller: addressController,
                            keyboardType: TextInputType.text,
                            type: 'Address',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 5, 10, 5),
                          child: CustomTextFormField(
                            labelText: 'Secondary Number',
                            hintText: 'Secondary Number',
                            controller: secPhoneController,
                            keyboardType: TextInputType.text,
                            type: 'Secondary_Number',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 15, 15, 5),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Simulate a delay for submission (or replace with your async _submit function)
                                  await _submit();

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
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Signup',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
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
      ),
    );
  }
}
