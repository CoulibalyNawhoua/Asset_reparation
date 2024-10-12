//fonction validation champ phone
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre numéro de téléphone';
  } else if (value.length != 10) {
    return 'Le numéro de téléphone doit contenir 10 chiffres';
  }
  return null;
}
String? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez saisir le montant';
  } else if (value.length != 10) {
    return 'Le montant est obligatoire';
  }
  return null;
}

//fonction validation champ password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez saisir un mot de passe';
  }
  return null;
}

//les tailles
width(context) => MediaQuery.of(context).size.width;
height(context) => MediaQuery.of(context).size.height;

//initail des noms de l'utilisateur connecté
String getInitials(String name) {
  // Divise le nom en parties et prend les deux premières lettres
  List<String> nameParts = name.split(' ');
  if (nameParts.length >= 2) {
    return nameParts[0][0] + nameParts[1][0]; // Combine les premières lettres des deux parties
  } else if (nameParts.isNotEmpty) {
    return nameParts[0].substring(0, 2); // Si une seule partie, prend les deux premières lettres
  }
  return '';
}

void openMap(double latitude, double longitude) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await launchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
}

class MapUtils {
  MapUtils._();

  static Future<void>openMap(double latitude,double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if(await launchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
   }
 }

}
String formatPrice(String montant) {
  final currencyFormatter = NumberFormat("#,##0 fcfa", "fr_FR");
  return currencyFormatter.format(double.parse(montant));
}
