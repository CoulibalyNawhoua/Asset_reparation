import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constantes/api.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/facture.dart';
import '../../fonctions/fonctions.dart';

class DetailFacturePage extends StatefulWidget {
  final int id;
  const DetailFacturePage({super.key, required this.id});

  @override
  State<DetailFacturePage> createState() => _DetailFacturePageState();
}

class _DetailFacturePageState extends State<DetailFacturePage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final FactureController factureController = Get.put(FactureController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      factureController.fetchDetailFacture(widget.id);
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
          "Détail facture",
          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (factureController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detailFacture = factureController.factureDetails.value;
        if (detailFacture == null) {
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
                      _buildRowItem("Référence:", detailFacture.reference),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Montant:", formatPrice(detailFacture.montant.toString())),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Libelé:", detailFacture.libelle),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Date de création:", DateFormat('dd MMMM yyyy: HH\'h\'mm','fr_FR').format(detailFacture.createdAt),),
                      const SizedBox(height: 10.0,),
                      _buildRowItemStatus("Status:", detailFacture.status),
                      const SizedBox(height: 10.0,),
                      if(detailFacture.commentaire != null) ...[
                        _buildRowItemMotif("Motif du rejet:", detailFacture.commentaire),
                      ],
                      const SizedBox(height: 10.0,),
                      buildRowItemImage("Image du materiel:", detailFacture.photo ?? "Aucune image ajouté"),

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
                      _buildRowItem("Code:",detailFacture.intervention.code),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Type d'intervenetion:",detailFacture.intervention.typeIntervention.libelle),
                      const SizedBox(height: 10.0,),
                      _buildRowItem("Mteriel:",detailFacture.intervention.materiel.article.libelle),
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
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
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