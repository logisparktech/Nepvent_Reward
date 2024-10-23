import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Screen/DashboardWidget.dart';
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
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: nameController,
                            autofocus: true,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD2D7DE),
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
                                  color: Color(0xFFD50032),
                                  // Keep the same color as enabled border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
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
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (input) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              // Uncomment if you want to validate against letters and spaces only
                              // if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              //   return 'Please enter a valid name (letters and spaces only)';
                              // }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: emailController,
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD2D7DE),
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
                                  color: Color(0xFFD50032),
                                  // Keep the same color as enabled border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
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
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (input) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Basic email pattern validation
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD2D7DE),
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
                                  color: Color(0xFFD50032),
                                  // Keep the same color as enabled border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
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
                                onTap: () =>
                                    setState(() => _isObscured = !_isObscured),
                                child: Icon(
                                  _isObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(0xFFD50032),
                                  size: 22,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: conPasswordController,
                            autofocus: false,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD2D7DE),
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
                                  color: Color(0xFFD50032),
                                  // Keep the same color as enabled border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
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
                                onTap: () =>
                                    setState(() => _isObscured = !_isObscured),
                                child: Icon(
                                  _isObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(0xFFD50032),
                                  size: 22,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (input) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: phoneController,
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFD2D7DE),
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
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
                                  // Keep the same color as focused border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorStyle: const TextStyle(
                                color: Color(0xFFD50032),
                                fontSize: 12, // Adjust font size as needed
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              // color:
                              // const Color.fromARGB(
                              //     255, 40, 40, 40),
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
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              hint: Text(
                                // 'प्रदेश छान्नुहोस्',
                                'Select the province',
                                style: TextStyle(fontSize: 16),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                // color:
                                // Color(0xFFB3A194),
                                size: 24,
                              ),
                              // dropdownColor:
                              // const Color.fromARGB(
                              //     255, 40, 40, 40),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                                // color: const Color(
                                //     0xFFB3A194),
                              ),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
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
                                            overflow: TextOverflow
                                                .ellipsis, // Truncates if needed
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
                                            overflow: TextOverflow
                                                .ellipsis, // Truncates if needed
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
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              hint: Text(
                                'Select the district',
                                style: TextStyle(
                                  // color: const Color(
                                  //     0xFFB3A194),
                                  fontSize: 16,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                // color:
                                // Color(0xFFB3A194),
                                size: 24,
                              ),
                              // dropdownColor:
                              // const Color.fromARGB(
                              //     255, 40, 40, 40),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                                // color: const Color(
                                //     0xFFB3A194),
                              ),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: addressController,
                            autofocus: false,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Address',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              labelText: 'Address',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                                  color: Color(0xFFD50032),
                                  // Keep the same color as enabled border
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // Optional: Keep same design for focused error
                                borderSide: const BorderSide(
                                  color: Color(0xFFD50032),
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
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (input) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return 'Please enter your Address';
                              // }
                              // if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              //   return 'Please enter a valid name (letters and spaces only)';
                              // }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: TextFormField(
                            controller: secPhoneController,
                            autofocus: true,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Secondary Number',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              labelText: 'Secondary Number',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 15, 15, 5),
                          child: SizedBox(
                            height: 45,
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
