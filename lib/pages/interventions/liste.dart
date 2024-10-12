import 'package:app_asset_reparateur/pages/interventions/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/intervention.dart';
import '../../fonctions/fonctions.dart';

class ListTicketPage extends StatefulWidget {
  const ListTicketPage({super.key});

  @override
  State<ListTicketPage> createState() => _ListTicketPageState();
}

class _ListTicketPageState extends State<ListTicketPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TicketController ticketController = Get.put(TicketController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      ticketController.fetchTicket();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Liste des interventions ",
          style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResearch(),
            const SizedBox(height: 20.0,),
            Expanded(
              child: Obx(() {
                if (ticketController.isLoading.value) {
                  return Center(child: Container());
                }
                if (ticketController.filteredTickets.isEmpty) {
                  return Center(child: Text('Aucune intervention trouvée.',style: TextStyle(color: Colors.red),));
                }
                return RefreshIndicator(
                  onRefresh: () async{ticketController.fetchTicket();},
                  child: ListView.builder(
                    itemCount: ticketController.filteredTickets.length,
                    itemBuilder: (context, index) {
                      final ticket = ticketController.filteredTickets[index];
                      return TicketItem(
                        name: ticket.dPdv, 
                        code: ticket.code, 
                        date: ticket.createdAt, 
                        status: ticket.status, 
                        onPressed: (){
                          Get.to(DetailTicketPage(uuid: ticket.uuid,));
                        },
                        latitude: ticket.dLatitude,
                        longitude: ticket.dLongitude,
                      );
                    },
                  ),
                );
              }),
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
                onChanged: (value) {
                  ticketController.filterTickets(value);  // Filtrer les boulangeries
                },
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final String name;
  final String code;
  // final String date;
  final DateTime date;
  final int status;
  final VoidCallback onPressed;
  final String latitude;
  final String longitude;

  const TicketItem ({
    super.key,
    required this.name,
    required this.code,
    required this.date,
    required this.status,
    required this.onPressed,   
    required this.latitude,
    required this.longitude,
  });

  

  @override
  Widget build(BuildContext context) {

    String statusText;
    Color statusColor;

    switch (status) {
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
                    title: Text(name,style: const TextStyle(fontSize: 14.0),),
                    subtitle: Text(DateFormat('dd MMMM yyyy','fr_FR').format(date),style: const TextStyle(fontSize: 10.0),),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(code,style: const TextStyle(fontSize: 14.0),),
                    subtitle: Text(statusText,style: TextStyle(color: statusColor, fontSize: 12.0)),
                  ),
                ),
                IconButton(
                  onPressed: (){MapUtils.openMap(double.parse(latitude), double.parse(longitude));}, 
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  )
                )
              ],
            ),
            const Divider(height: 1, thickness: 1,),
          ],
        )
      ),
    );
  }
}


