import 'package:flutter/material.dart';

import '../constantes/constantes.dart';
import '../fonctions/fonctions.dart';

class CButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  const CButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    var border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: border,
        // backgroundColor: AppColors.secondaryColor,
        backgroundColor: isLoading ? AppColors.secondaryColor : AppColors.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: width(context),
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
          : Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
      ),
      // child: SizedBox(
      //   width: width(context),
      //   child: Text(
      //       title,
      //       textAlign: TextAlign.center,
      //       style: const TextStyle(fontSize: 20, color: Colors.white),
      //     ),
      // ),
    );
  }
}

class CTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CTextButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 30,
      child: ElevatedButton(
      onPressed: null, 
      style: ButtonStyle(
        // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Couleur du bouton
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
      child: const Text('Valider',style: TextStyle(fontSize: 12.0), )
      )
    );
  }
}
