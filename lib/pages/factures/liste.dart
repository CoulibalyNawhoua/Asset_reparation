import 'package:app_asset_reparateur/pages/factures/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/devis.dart';
import '../../controllers/facture.dart';
import '../devis/detail.dart';

class ListeFacturePage extends StatefulWidget {
  const ListeFacturePage({super.key});

  @override
  State<ListeFacturePage> createState() => _ListeFacturePageState();
}

class _ListeFacturePageState extends State<ListeFacturePage> with TickerProviderStateMixin {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DevisController devisController = Get.put(DevisController());
  final FactureController factureController = Get.put(FactureController());
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
      setState(() {
        authenticateController.checkAccessToken();
        devisController.fetchDevis();
        factureController.fetchFacture();
        tabController = TabController(length: 2, vsync: this); // onglets fixes
      });
  }

  List<Tab> _generateTabs() {
    return [
      Tab(text: 'Devis'),
      Tab(text: 'Factures'),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Liste des factures et devis ",
          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // _buildResearch(),
            SizedBox(height: 10.0,),
            TabBar(  
              controller: tabController,
              tabs: _generateTabs(),
              labelColor: AppColors.secondaryColor,
              unselectedLabelColor: AppColors.primaryColor,
              indicatorColor: AppColors.secondaryColor,
              // labelStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              // labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: () async{devisController.fetchDevis();},
                    child: Obx(() {
                      if (devisController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (devisController.devis.isEmpty) {
                        return Center(child: Text('Aucun devis envoyé.',style: TextStyle(color: Colors.red),));
                      }

                      return ListView.builder(
                        itemCount: devisController.devis.length,
                        itemBuilder: (context, index) {
                          final devis = devisController.devis[index];
                          return DevisItem(
                            libelle: devis.libelle, 
                            reference: devis.reference, 
                            date: devis.createdAt, 
                            status: devis.status, 
                            onPressed: (){Get.to(DetailDevisPage(id: devis.id));},
                          );
                        },
                      );
                    }),
                  ),
                  RefreshIndicator(
                    onRefresh: () async{factureController.fetchFacture();},
                    child: Obx(() {

                      if (factureController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (factureController.factures.isEmpty) {
                        return Center(child: Text('Aucune facture envoyées.',style: TextStyle(color: Colors.red),));
                      }

                      return ListView.builder(
                        itemCount: factureController.factures.length,
                        itemBuilder: (context, index) {
                          final facture = factureController.factures[index];
                          return DevisItem(
                            libelle: facture.libelle, 
                            reference: facture.reference, 
                            date: facture.createdAt, 
                            status: facture.status, 
                            onPressed: (){Get.to(DetailFacturePage(id: facture.id));},
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResearch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: searchController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: 'Recherche',
                  border: InputBorder.none,
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DevisItem extends StatelessWidget {
  final String libelle;
  final String reference;
  final DateTime date;
  final int status;
  final VoidCallback onPressed;

  const DevisItem ({
    super.key,
    required this.libelle,
    required this.reference,
    required this.date,
    required this.status,
    required this.onPressed,   
  });

  

  @override
  Widget build(BuildContext context) {

    String statusText;
    Color statusColor;

    switch (status) {
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

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(reference,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,),),
                    subtitle: Text(statusText,style: TextStyle(color: statusColor, fontSize: 12.0)),
                  ),
                ),
                 Expanded(
                  child: ListTile(
                    title: Text(libelle,style: TextStyle(fontSize: 14.0,),),
                    subtitle: Text(DateFormat('dd MMMM yyyy','fr_FR').format(date),style: const TextStyle(fontSize: 10.0),),
                  ),
                ),
                // const Icon(Icons.navigate_next),
              ],
            ),
            const Divider(height: 1, thickness: 1,),
          ],
        )
      ),
    );
  }
}


