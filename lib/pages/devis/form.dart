import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../composants/appbar.dart';
import '../../composants/button.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/devis.dart';

class FormDevisPage extends StatefulWidget {
  final String uuid;
  const FormDevisPage({super.key, required this.uuid});

  @override
  State<FormDevisPage> createState() => _FormDevisPageState();
}

class _FormDevisPageState extends State<FormDevisPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DevisController devisController = Get.put(DevisController());
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  File? image;  // Un seul fichier image

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Caméra'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void saveForm() {
    if (formKey.currentState!.validate()) {

      if (image == null) {
        Get.snackbar(
          "Erreur",
          "Veuiller ajouté une photo .",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String montant = montantController.text;
      String libelle = libelleController.text;
      File? selectedImage = image;

      print('Montant: $montant');
      print('Libelle: $libelle');

      if (selectedImage != null) {
        print('Image: ${selectedImage.path}');
      } else {
        print('Aucune image sélectionnée');
      }
      devisController.saveDevise(
        uuid: widget.uuid, 
        montant: montant, 
        libelle: libelle, 
        image: image!,
      );
    }
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      montantController.clear();
      libelleController.clear();
      imageController.clear();
      image = null; // Effacer l'image
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(
        title: "Formulaire de devis", 
        onPressed: (){
          // Get.to(DetailTicketPage(uuid: widget.uuid));
        }
      ),
       body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: _form()
          ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: libelleController,
                decoration: InputDecoration(
                  labelText: "Entrez un libelé",
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: border,
                  hintText: "Entrez un libelé",
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir le libelé";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0,),

              TextFormField(
                controller: montantController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryColor)
                  ),
                  hintText: "Entrez le montant du devis",
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  labelText: "Entrez un montant",
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  prefixIcon: const Icon(Icons.money,color: AppColors.primaryColor,size: 16,),
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir le montant";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0,),
              textButom("Ajouter une photo du devis", () { _showPicker(imageController);}),
              _buildImageGrid(),
              const SizedBox(height: 50),
              Obx(() {
                return CButton(
                  title: "ENVOYER",
                  isLoading: devisController.isLoading.value,
                  onPressed: () async {saveForm();},
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: image != null 
          ? Stack(
              children: [
                Image.file(
                  image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                // Positioned(
                //   right: 0,
                //   child: IconButton(
                //     icon: const Icon(Icons.cancel, color: Colors.red),
                //     onPressed: () {
                //       setState(() {
                //         image = null;
                //       });
                //     },
                //   ),
                // ),
              ],
            )
          : const Text("Aucune image sélectionnée"),
    );
  }



  Widget textButom(String title,VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor), // Couleur du bouton
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
      child: Text(title,style: const TextStyle(fontSize: 12.0), )
    );
  }
}