import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.type,
  });

  final String type;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;

  final TextEditingController controller;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String _errorText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      String value = widget.controller.text;
      String typeCase = widget.type.toLowerCase();
      switch (typeCase) {
        case 'phone_number':
          if (value.isEmpty) {
            _errorText = 'Please enter your phone number';
          } else if (!RegExp(r'^9\d{9}$').hasMatch(value)) {
            _errorText = 'Please enter a valid 10-digit number starting with 9';
          } else {
            _errorText = '';
          }
          break;
        case 'name':
          if (value.isEmpty) {
            _errorText = 'Please enter your name';
          } else {
            _errorText = '';
          }
          break;
        case 'email':
          if (value.isEmpty) {
            _errorText = 'Please enter your email';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            _errorText = 'Please enter a valid email';
          } else {
            _errorText = '';
          }
          break;
        default:
          _errorText = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: false,
      obscureText: false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.grey[500],
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
            color: Color(0xFFD2D7DE),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFD2D7DE),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorText: _errorText,
        errorStyle: const TextStyle(
          color: Color(0xFFD50032),
          fontSize: 12,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    );
  }
}
