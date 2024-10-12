import 'dart:convert';
import 'dart:developer';

import 'package:app_asset_reparateur/composants/base.dart';
import 'package:app_asset_reparateur/pages/interventions/liste.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../models/Ticket.dart';
import '../pages/interventions/details.dart';

class TicketController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Ticket> tickets = <Ticket>[].obs;
  Rx<Intervention?> interventions = Rx<Intervention?>(null);
  RxList<Ticket> filteredTickets = <Ticket>[].obs; // Liste filtrée

  // Variables observables pour stocker les totaux et pourcentages
  RxMap<String, RxDouble> percentages = <String, RxDouble>{}.obs;
  RxInt interventionAffectTotal = 0.obs;
  RxInt interventionAffectSucces = 0.obs;
  RxInt interventionAffectEchec = 0.obs;

  
  @override
  void onInit() {
    super.onInit();
    fetchTicket();  // Charger les tickets lors de l'initialisation
    fetchTotalAndPercentage();
  }


  void filterTickets(String query) {
    if (query.isEmpty) {
      filteredTickets.assignAll(tickets);  // Réinitialiser la liste filtrée
    } else {
      filteredTickets.assignAll(tickets.where((ticket) =>
        ticket.dPdv.toLowerCase().contains(query.toLowerCase())
      ).toList());
    }
  }

  Future<void> fetchTicket() async {
    try {
      isLoading.value = true;
      tickets.clear();
      var response = await http.get(Uri.parse(Api.listTicket), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Ticket> ticketList = data.map((json) => Ticket.fromJson(json)).toList();
        // inspect(ticketList);
        tickets.assignAll(ticketList);
        filteredTickets.assignAll(ticketList); // Appliquer le filtre initial
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des tickets");
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

    
  Future<void> fetchDetailTicket(String uuid) async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(Api.ticketDetails(uuid)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {

        var responseBody = jsonDecode(response.body);
        var demandeData = responseBody['data'];
        interventions.value = Intervention.fromJson(demandeData);
// inspect(demandeData);
      } else {
       inspect('Erreur lors de la récupération des détails du ticket.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveConfirmed({
    required String uuid,
    required String numSerie,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'num_serie': numSerie,
      };
      var response = await http.post(
        Uri.parse(Api.confirmation(uuid)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      
      if (response.statusCode == 200) {

        isLoading.value = false;
        var responseBody = json.decode(response.body);

        if (responseBody["code"] == 400) {
          Get.snackbar(
            'Echec',
            responseBody["msg"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }else{
          Get.snackbar(
            'Succès',
            'Le numero de série a été soumis avec succès.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          await fetchDetailTicket(uuid);
          Get.to(DetailTicketPage(uuid: uuid,));
        }

      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'Aucun numero scanné à soumettre.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        if (kDebugMode) {
          print("Échec de la soumission");
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> fetchTotalAndPercentage() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(Api.dash),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        
        isLoading.value = false;
        var responseBody = jsonDecode(response.body)["data"];

        interventionAffectTotal.value = responseBody["intervention_affect_total"];
        interventionAffectSucces.value = responseBody["intervention_affect_succes"];
        interventionAffectEchec.value = responseBody["intervention_affect_echec"];

        // Calcul des pourcentages
        if (interventionAffectTotal.value > 0) {
          percentages['succes'] = (interventionAffectSucces.value / interventionAffectTotal.value).obs;
          percentages['echec'] = (interventionAffectEchec.value / interventionAffectTotal.value).obs;
          percentages['total'] = 1.0.obs;
        } else {
          percentages['succes'] = 0.0.obs;
          percentages['echec'] = 0.0.obs;
          percentages['total'] = 0.0.obs;
        }
       
      } else {
        isLoading.value = false;
        print('Erreur lors de la récupération des résumés de demande');
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      } 
    }
  }

  Future<void> saveRapport({
    required String uuid,
    required String description
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'motif_rejet': description,
      };
      var response = await http.post(
        Uri.parse(Api.annulation(uuid)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      if (response.statusCode == 200) {

        isLoading.value = false;
        var responseBody = json.decode(response.body);

        if (responseBody["code"] == 400) {
          Get.snackbar(
            'Echec',
            responseBody["msg"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }else{
          Get.snackbar(
            'Succès',
            'Rapport envoyé avec succès.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          await fetchTotalAndPercentage();
          // Get.off(BaseApp());
        }

      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'Aucun rapport à soumettre.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        if (kDebugMode) {
          print("Échec de la soumission");
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }


}


