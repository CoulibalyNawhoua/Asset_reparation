import 'package:app_asset_reparateur/pages/devis/form.dart';
import 'package:app_asset_reparateur/pages/factures/form.dart';
import 'package:app_asset_reparateur/pages/rapport/add-rapport.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../composants/appbar.dart';
import '../../constantes/api.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/intervention.dart';
import '../../fonctions/fonctions.dart';
import '../scanne/scanner.dart';

class DetailTicketPage extends StatefulWidget {
  final String uuid;
  const DetailTicketPage({super.key, required this.uuid});

  @override
  State<DetailTicketPage> createState() => _DetailTicketPageState();
}

class _DetailTicketPageState extends State<DetailTicketPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TicketController ticketController = Get.put(TicketController());

  double distanceM = 0;
  bool isWithinRange = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      ticketController.fetchDetailTicket(widget.uuid);
      ticketController.fetchTicket();
      calculateDistance();
    });
    
  }

  // fonction de localisation d'un utilisateur
  Future<void> calculateDistance() async {
    // Demander les permissions de localisation
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Le service de localisation est désactivé.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Les permissions de localisation sont définitivement refusées, nous ne pouvons pas demander les permissions.');
    }

    // Obtenir la position actuelle de l'utilisateur
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Définir les coordonnées du point spécifique
      // Récupérer les détails du ticket
    final intervention = ticketController.interventions.value;
    if (intervention == null) {
      return Future.error('Aucun détail du ticket trouvé');
    }
    // Extraire les coordonnées du point spécifique
    double pointLatitude = double.parse(intervention.dLatitude);
    double pointLongitude = double.parse(intervention.dLongitude);

    // double pointLatitude = 5.3862285;
    // double pointLongitude = -3.9827405;
 
    // Calculer la distance entre la position actuelle et le point spécifique en mètre
    double distanceMm = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      // pointLatitude,
      // pointLongitude,
      position.latitude,
      position.longitude,
    );

    if (mounted) {
      setState(() {
        distanceM = distanceMm;
        isWithinRange = distanceM <= 200;
        isLoading = false;
      });
    }
  }

  Widget buildShimmerButton({required String text}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(
        title: "Intervention détail",
        onPressed: () {
          Get.back();
          ticketController.fetchTicket();
          ticketController.fetchTotalAndPercentage();
        },

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            if (ticketController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              final intervention = ticketController.interventions.value;
              if (intervention == null) {
                return Center(child: Text("Aucun détail trouvé"));
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await ticketController.fetchDetailTicket(widget.uuid);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          icon(() {
                            openMap(double.parse(intervention.dLatitude), double.parse(intervention.dLongitude));
                          }),
                          if (intervention.status == 0) ...[
                            isLoading
                              ? buildShimmerButton(text: "Confirmer")
                              : ElevatedButton(
                                  onPressed: isWithinRange
                                    ? () {
                                        Get.to(ScannerPage(uuid: intervention.uuid));
                                      }
                                    : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      isWithinRange ? AppColors.secondaryColor : Colors.grey,
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  child: const Text("Confirmer"),
                                ),
                            isLoading
                              ? buildShimmerButton(text: "Rejeté le ticket")
                              : ElevatedButton(
                                  onPressed: isWithinRange
                                    ? () {
                                        Get.to(RapportPage(uuid: intervention.uuid));
                                      }
                                    : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      isWithinRange ? Colors.red : Colors.grey,
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  child: const Text("Rejeté le ticket"),
                                ),
                          ] else if (intervention.status == 1) ...[
                            isLoading
                              ? buildShimmerButton(text: "Faire le devis")
                              : ElevatedButton(
                                  onPressed: isWithinRange
                                    ? () {
                                      print(intervention.uuid);
                                        Get.to(FormDevisPage(uuid: intervention.uuid));
                                      }
                                    : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      isWithinRange ? AppColors.primaryColor : Colors.grey,
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  child: const Text("Devis"),
                                ),
                          ] else if (intervention.status == 2) ...[
                            isLoading
                              ? buildShimmerButton(text: "Faire Facture")
                              : ElevatedButton(
                                  onPressed: isWithinRange
                                    ? () {
                                      print(intervention.uuid);
                                        Get.to(FormFacturePage(uuid: intervention.uuid));
                                      }
                                    : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      isWithinRange ? AppColors.primaryColor : Colors.grey,
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  child: const Text("Faire la facture"),
                                ),
                          ]
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Informations du ticket",style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(height: 20.0,),
                            buildRowItem("Code du ticket:", intervention.code),
                            const SizedBox(height: 10.0,),
                            buildRowItem("Date de création:", DateFormat('dd MMM yyyy HH:mm','fr_FR').format(intervention.createdAt)),
                            const SizedBox(height: 10.0,),
                            buildRowItem("type d'intervention:", intervention.typeIntervention.libelle),
                            const SizedBox(height: 10.0,),
                            buildRowItemStatus("Status", intervention.status),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20.0,),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Informations du point de vente",style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(height: 20.0,),
                            buildRowItem("Nom du pdv:", intervention.dPdv),
                            const SizedBox(height: 10.0,),
                            buildRowItem("Contact du pdv:", intervention.dContact),
                            const SizedBox(height: 10.0,),
                            buildRowItem("Adresse du pdv:", intervention.dAddresse),
                            const SizedBox(height: 10.0,),
                            buildRowItem("Distance du pdv:",'${distanceM.toStringAsFixed(1)} m' ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      if (intervention.materiel != null)
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Information du matériel", style: TextStyle(fontWeight: FontWeight.bold),),
                              const SizedBox(height: 20.0,),
                              if (intervention.status != 0) ...[
                                buildRowItem("Libellé:", intervention.materiel!.materielDetails.libelle),
                                const SizedBox(height: 20.0,),
                                buildRowItem("Catégories:", intervention.materiel!.materielDetails.categorie.libelle),
                                const SizedBox(height: 20.0,),
                                buildRowItem("Marques:", intervention.materiel!.materielDetails.marque.libelle),
                                const SizedBox(height: 20.0,),
                                buildRowItem("Modèle:", intervention.materiel!.materielDetails.modele.libelle),
                                const SizedBox(height: 20.0,),
                                buildRowItem("Description:", intervention.noteCommercial ?? "Aucune description disponible"),
                                const SizedBox(height: 20.0,),
                                buildRowItemImage("Image du materiel:", intervention.photoMateriel ?? "", intervention.photoMaterielTwo ?? ""),
                              ] else ...[
                                buildRowItem("Description:", intervention.noteCommercial ?? "Aucune description disponible"),
                                const SizedBox(height: 20.0,),
                                buildRowItemImage("Image du materiel:", intervention.photoMateriel ?? "", intervention.photoMaterielTwo ?? ""),
                              ]
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
            }
          }),
        ),
      ),
    );
  }
  
  Widget buildRowItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget buildRowItemImage(String title, String image1, String image2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 10.0), // Un peu d'espace entre le titre et les images
        Column(
          children: [
            image1.isNotEmpty
              ? Image.network(
                  "${Api.imageUrl}${image1}",
                  width: width(context),
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Text('Image non disponible'),

            const SizedBox(height: 10.0),

            image2.isNotEmpty
              ? Image.network(
                  "${Api.imageUrl}${image2}",
                  width: width(context),
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Text('Image non disponible'),
          ],
        ),
      ],
    );
  }


  Widget buildRowItemStatus(String title, int value) {
    String statusText;
    Color statusColor;

    switch (value) {
      case 0:
        statusText = "En attente de confirmation";
        statusColor = Colors.yellow.shade900;
        break;
      case 1:
        statusText = "En attente de devis";
        statusColor = Colors.yellow.shade900;;
        break;
      case 2:
        statusText = "En attente de facture ";
        statusColor = Colors.yellow.shade900;;
        break;
      case 3:
        statusText = "Echec ";
        statusColor = Colors.red;;
        break;
      default:
        statusText = "Terminer";
        statusColor = Colors.green;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          statusText,
          style: TextStyle(color: statusColor),
        )
      ],
    );
  }
  Widget icon(VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed, 
      icon: const Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 30.0,

      )
    );
  }
}

