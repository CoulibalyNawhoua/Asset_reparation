import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_asset_reparateur/pages/interventions/details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constantes/api.dart';
import '../models/Devis.dart';

class DevisController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;
  RxList<Devis> devis = <Devis>[].obs;
  Rx<DetailDevis?> devisDetails = Rx<DetailDevis?>(null);

  Future<void> saveDevise({
    required String uuid,
    required String montant,
    required String libelle,
    required File image,
  }) async {

    try {
      isLoading.value = true;
      // var data = {
      //   'libelle': libelle,
      //   'montant': montant,
      //   'photo': image,
      // };
      var request = http.MultipartRequest('POST', Uri.parse(Api.createDevis(uuid)),);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      // Ajouter les champs de texte
      request.fields['libelle'] = libelle;
      request.fields['montant'] = montant;

      // Ajouter les fichiers image
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        image.path,
        contentType: MediaType('image', 'jpeg'), // ou le type MIME approprié pour vos images
      ));


      // Envoyer la requête
      var response = await request.send();
      if (response.statusCode == 200) {

        var responseData = await http.Response.fromStream(response);
        var responseBody = json.decode(responseData.body);
      
        if (responseBody["code"] == 400) {
          Get.snackbar(
            "Echec",
            responseBody["msg"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }else{
          Get.snackbar(
            "Succès",
            "Devis envoyé avec succès.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.to(DetailTicketPage(uuid: uuid,));
          
        }
       
      } else {
        Get.snackbar(
          "Erreur",
          "Erreur lors de l'envoie du devis.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      inspect("Exception lors de l'envoie du devis': $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDevis() async {
    try {
      isLoading.value = true;
      devis.clear();
      var response = await http.get(Uri.parse(Api.listDevis), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Devis> devistList = data.map((json) => Devis.fromJson(json)).toList();
        // inspect(devistList);
        devis.assignAll(devistList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des devis");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

   Future<void> fetchDetailDevis(int id) async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(Api.detailFacture(id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {

        var responseBody = jsonDecode(response.body);
        var devisData = responseBody['data'];
        devisDetails.value = DetailDevis.fromJson(devisData);
        inspect(devisDetails.value);

      } else {
        print('Erreur lors de la récupération des détails de  devis');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
}