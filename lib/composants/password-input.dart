import 'package:flutter/material.dart';

import '../constantes/constantes.dart';

class PasswordInput extends StatefulWidget {
  final TextInputType inputType;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordInput({
    super.key,
    required this.inputType,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validator,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryColor)
    );
     var prefixIcon = Icon(widget.icon,color: AppColors.primaryColor,size: 16,);
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: border,
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.primaryColor),
        prefixIcon: prefixIcon,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primaryColor,
            size: 16,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        enabledBorder: border,
      ),
      validator: widget.validator,
      textInputAction: TextInputAction.done,
    );
     
  
  }
}

