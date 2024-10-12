import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constantes/api.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/devis.dart';
import '../../fonctions/fonctions.dart';
import '../interventions/liste.dart';

class DetailDevisPage extends StatefulWidget {
  final int id;
  const DetailDevisPage({super.key, required this.id});

  @override
  State<DetailDevisPage> createState() => _DetailDevisPageState();
}

class _DetailDevisPageState extends State<DetailDevisPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DevisController devisController = Get.put(DevisController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      devisController.fetchDetailDevis(widget.id);
    });
    
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Détail devis",
          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
          onPressed: () {
            // Get.to(const ListTicketPage());
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (devisController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detailDevis = devisController.devisDetails.value;
        if (detailDevis == null) {
          return const Center(child: Text("Aucune facture trouvée",style: TextStyle(color: Colors.red),));
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: height(context) * 0.03, horizontal: width(context) * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Information de la facture",style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20.0,),
                      _buildRowItem("Référence:", detailDevis.reference),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Montant:", formatPrice(detailDevis.montant.toString())),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Libelé:", detailDevis.libelle),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Date de création:", DateFormat('dd MMMM yyyy: HH\'h\'mm','fr_FR').format(detailDevis.createdAt),),
                      const SizedBox(height: 10.0,),
                      _buildRowItemStatus("Status:", detailDevis.status),
                      const SizedBox(height: 10.0,),
                      if(detailDevis.commentaire != null) ...[
                      _buildRowItemMotif("Motif du rejet:", detailDevis.commentaire),
                      ],
                      const SizedBox(height: 10.0,),
                      buildRowItemImage("Image du materiel:", detailDevis.photo ?? ""),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Information de l'intervention",style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20.0,),
                      _buildRowItem("Code:",detailDevis.intervention.code),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Type d'intervenetion:",detailDevis.intervention.typeIntervention.libelle),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Mteriel:",detailDevis.intervention.materiel.article.libelle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

   Row _buildRowItemStatus(String title, int value) {
   String statusText;
    Color statusColor;

    switch (value) {
      case 0:
        statusText = "En cours de validation";
        statusColor = Colors.yellow.shade900;
        break;
      case 1:
        statusText = "Validé";
        statusColor = Colors.green;;
        break;
      default:
        statusText = "Rejété";
        statusColor = Colors.red;
        break;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          statusText,
          style: TextStyle(color: statusColor),
        )
      ],
    );
  }

  Widget _buildRowItem(String title, String value) {
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

  Widget _buildRowItemMotif(String title, String value) {
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
            style: const TextStyle(fontSize: 12,color: Colors.red),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget buildRowItemImage(String title, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
          image.isNotEmpty
            ? Image.network(
                "${Api.imageUrl}${image}",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : const Text('Image non disponible'),
      ],
    );
  }
}