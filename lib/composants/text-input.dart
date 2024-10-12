import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constantes/constantes.dart';

class TextInput extends StatelessWidget {
  final TextInputType inputType;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
    
  const TextInput({
    super.key,
    required this.inputType,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {

    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryColor)
    );
    var prefixIcon = Icon(icon,color: AppColors.primaryColor,size: 16,);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: border,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.primaryColor),
        prefixIcon: prefixIcon,
        enabledBorder: border,
      ),
      keyboardType: inputType,
      validator: validator,
      inputFormatters: [ //pour limiter la longueur de la saisie à 10 chiffres.
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ], 
    );
   
    
  }
}

