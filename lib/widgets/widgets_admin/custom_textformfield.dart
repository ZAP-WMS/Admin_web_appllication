import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

class CustomFormTextField extends StatefulWidget {
  final TextEditingController controller;
  String labeltext;
  bool isSuffixIcon = false;
  final String? Function(String?)? validatortext;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  CustomFormTextField(
      {super.key,
      required this.controller,
      required this.labeltext,
      required this.isSuffixIcon,
      this.validatortext,
      required this.keyboardType,
      required this.textInputAction});

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: widget.controller,
      onChanged: (value) => widget.labeltext,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          labelText: widget.labeltext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey)),
          suffixIcon: widget.isSuffixIcon
              ? InkWell(
                  onTap: _togglePasswordView,
                  child: _isHidden
                      ? const Icon(Icons.visibility)
                      : Icon(
                          Icons.visibility_off,
                          color: grey,
                        ))
              : const Text('')),
      validator: widget.validatortext,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _isHidden,
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
