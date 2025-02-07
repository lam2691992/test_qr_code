import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  final Function(String) onQRScanned;

  const QRScannerScreen({super.key, required this.onQRScanned});

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    void onQRViewCreated(QRViewController controller) {
      controller.scannedDataStream.listen((scanData) {
        onQRScanned(scanData.code ?? "No Data");
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
