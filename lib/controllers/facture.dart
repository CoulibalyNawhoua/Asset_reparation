import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_asset_reparateur/pages/interventions/details.dart';
import 'package:app_asset_reparateur/pages/interventions/liste.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constantes/api.dart';
import '../models/Facture.dart';

class FactureController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Facture> factures = <Facture>[].obs;
  Rx<DetailFacture?> factureDetails = Rx<DetailFacture?>(null);


  Future<void> saveFacture({
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
      var request = http.MultipartRequest('POST', Uri.parse(Api.createFacture(uuid)),);
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
      inspect(response);
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
            "Facture envoyée avec succès.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
           Get.to(DetailTicketPage(uuid: uuid,));
        }
       
      } else {
        Get.snackbar(
          "Erreur",
          "Erreur lors de l'envoie de la facture.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      inspect("Exception lors de l'envoie de la facture': $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFacture() async {
    try {
      isLoading.value = true;
      factures.clear();
      var response = await http.get(Uri.parse(Api.listFacture), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Facture> facturetList = data.map((json) => Facture.fromJson(json)).toList();
        // inspect(facturetList);
        factures.assignAll(facturetList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des factures");
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

  Future<void> fetchDetailFacture(int id) async {
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
        var factureData = responseBody['data'];
        factureDetails.value = DetailFacture.fromJson(factureData);
        inspect(factureDetails.value);

      } else {
        print('Erreur lors de la récupération des détails de la facture');
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