import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../composants/appbar.dart';
import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/intervention.dart';
import '../../fonctions/fonctions.dart';

class ScannerPage extends StatefulWidget {
  final String uuid;
  const ScannerPage({super.key, required this.uuid,});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TicketController ticketController = Get.put(TicketController());
  
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

@override
void reassemble() {
  super.reassemble();
  if (Platform.isAndroid) {
    controller?.pauseCamera();
  }
  controller?.resumeCamera();
}


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(
        title: "Scanner un QR code",
        onPressed: (){
          // Get.back();
        }
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
  setState(() {
    this.controller = controller;
  });
  controller.scannedDataStream.listen((scanData) {
    setState(() {
      result = scanData;
      controller.pauseCamera();
      _showConfirmationBottomSheet(scanData.code);
    });
  });

}


  void _showConfirmationBottomSheet(String? code) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Numero scanné avec succès !',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Le numero de série scanné est : $code',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Obx(() {
              return textButom(
                "Confirmation", 
                () => _submitScannedData(code), 
                ticketController.isLoading.value,
              );
            })
              
            ],
          ),
        );
      },
    );
  }

  void _submitScannedData(String? code) {
    if (code != null) {
      ticketController.saveConfirmed(numSerie: code, uuid: widget.uuid);
    } else {
      Get.snackbar("Erreur", "Aucun code scanné à soumettre.");
    }
  }

  void resetScanner() {
    setState(() {
      result = null;
    });
    controller?.resumeCamera();
  }
  
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget textButom(String title,VoidCallback onPressed,bool isLoading,) {
    var border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: border,
        backgroundColor: isLoading ? AppColors.secondaryColor : AppColors.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: width(context),
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
          : Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
      ),
    );
  }
}