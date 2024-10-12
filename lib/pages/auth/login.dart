
import 'package:app_asset_reparateur/composants/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../composants/button.dart';
import '../../composants/password-input.dart';
import '../../composants/text-input.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../fonctions/fonctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscurityText = true;
  final token = GetStorage().read("access_token");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final token = GetStorage().read("access_token");
      // inspect(token);
      if (token != null) {
        Get.offAll(() => const BaseApp());
      }
    });
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      String phone = phoneController.text;
      String password = passwordController.text;
      await authenticateController.login(phone: phone, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: SingleChildScrollView(child: _page())),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInput(
                    inputType: TextInputType.phone, 
                    hint: "Entrez votre numero de téléphone", 
                    icon: Icons.phone, 
                    controller: phoneController, 
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 20),
                  PasswordInput(
                    inputType: TextInputType.text, 
                    hint: "Entrez votre mot de passe", 
                    icon: Icons.lock, 
                    controller: passwordController, 
                    validator: validatePassword
                  ),
                  const SizedBox(height: 50),
                  Obx(() {
                    return CButton(
                      title: "CONNEXION",
                      isLoading: authenticateController.isLoading.value,
                      onPressed: () async {
                        submit();
                      },
                    );
                  }),
                  
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: width(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage("assets/images/logo.png"),
            width: 150,
          ),
          Text(
            "REPARATEUR",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 2
            ),
          ),
          // _header("Veuillez vous connecter avec vos informations"),
        ],
      ),
    );
  }

}