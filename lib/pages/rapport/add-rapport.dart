import 'package:app_asset_reparateur/composants/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../composants/appbar.dart';
import '../../composants/button.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/intervention.dart';
import '../interventions/liste.dart';

class RapportPage extends StatefulWidget {
  final String uuid;
  const RapportPage({super.key, required this.uuid});

  @override
  State<RapportPage> createState() => _RapportPageState();
}

class _RapportPageState extends State<RapportPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TicketController ticketController = Get.put(TicketController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      ticketController.fetchDetailTicket(widget.uuid);
      
    });
    
  }

  void saveForm() {
    if (formKey.currentState!.validate()) {
      String description = descriptionController.text;
      ticketController.saveRapport(
        uuid: widget.uuid, 
        description: description, 
      );
    
    }
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(
        title: "Rapport du rejet", 
        onPressed: (){
          Get.offAll(BaseApp());
          // Get.back();
          // ticketController.fetchDetailTicket(widget.uuid);
          ticketController.fetchTotalAndPercentage();
        }
      ),
       body: SingleChildScrollView(
        child: Center(
          child: _form()
        ),
      ),
    );
  }
    Widget _form() {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryColor)
    );

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Justification du rejet",
                    // labelText: "Entrer une description",
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: border,
                    enabledBorder: border,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une description";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20.0,),
              CButton(
                title: "ENREGISTRER", 
                isLoading: ticketController.isLoading.value,
                onPressed: (){
                  saveForm();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}