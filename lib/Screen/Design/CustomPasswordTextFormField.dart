import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  const CustomPasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.isPassword,
    this.password,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final TextEditingController? password;

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool _isObscured = true;
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
      if (widget.password == null ) {
        if (value == null || value.isEmpty) {
          _errorText = 'Please enter your password';
        } else if (value.length < 6) {
          _errorText = 'Password must be at least 6 characters long';
        } else {
          _errorText = '';
        }
      } else {
        if (value == null || value.isEmpty) {
          _errorText = 'Please confirm your password';
        } else if (value != widget.password!.text) {
          _errorText = 'Passwords do not match';
        } else {
          _errorText = '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: false,
      obscureText: _isObscured,
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
        suffixIcon: InkWell(
          onTap: () => setState(() => _isObscured = !_isObscured),
          child: Icon(
            _isObscured
                ?  MdiIcons.eyeOff
                : MdiIcons.eye,
            color: const Color(0xFFD50032),
            size: 22,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        // fontWeight: FontWeight.w600,
      ),
    );
  }
}
