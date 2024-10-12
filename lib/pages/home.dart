import 'package:app_asset_reparateur/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../composants/appbar.dart';
import '../constantes/constantes.dart';
import '../controllers/auth.dart';
import '../controllers/intervention.dart';
import '../models/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TicketController ticketController = Get.put(TicketController());
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      ticketController.fetchTicket();
      ticketController.fetchTotalAndPercentage();
      getUserData();
    });
  }

  Future<void> getUserData() async {
    var userData = GetStorage().read<Map<String, dynamic>>("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBarHome(
        name: user != null ? user!.useNom : "John Doe",
        value: "3",
        onPressed: () {
          Get.to(UserProfilePage());
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double itemWidth = (constraints.maxWidth - 40) / 2; // 20 spacing on both sides
                          return Obx(() => Wrap(
                            spacing: 20.0,
                            runSpacing: 20.0,
                            children: [
                              _buildGridItem(
                                "Toutes les réparations",
                                ticketController.percentages['total'] ?? 0.0.obs,
                                ticketController.interventionAffectTotal,
                                Colors.blue.shade100,
                                itemWidth,
                              ),
                              _buildGridItem(
                                "Réparations acceptées",
                                ticketController.percentages['succes'] ?? 0.0.obs,
                                ticketController.interventionAffectSucces,
                                Colors.green.shade100,
                                itemWidth,
                              ),
                              
                              _buildGridItem(
                                "Réparations annulées",
                                ticketController.percentages['echec'] ?? 0.0.obs,
                                ticketController.interventionAffectEchec,
                                Colors.red.shade100,
                                itemWidth,
                              ),
                            ],
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, RxDouble percentage, RxInt total,Color color, double width) {
    return Container(
      width: width,
      height: 200,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: percentage.value,
            animation: true,
            animationDuration: 500,
            center: Text(
              "${(percentage.value * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: Colors.blue,
            circularStrokeCap: CircularStrokeCap.butt,
          ),
          const SizedBox(width: 10.0),
          Text(
            "Total: ${total.value}",
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      )),
    );
  }
}

