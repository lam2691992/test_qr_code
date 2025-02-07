import 'package:flutter/material.dart';
import 'package:qr_scanner/screen/qr_scanner_screen.dart';
import '../utils/url_launcher.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> scanHistory = [];

  bool isScanning = false;
  @override
  void initState() {
    super.initState();
  }

  void _launchQRScanner() {
    if (isScanning) return; // Ngăn mở nhiều lần

    isScanning = true; // Đặt trạng thái đang quét
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onQRScanned: (String scannedData) {
            if (!scanHistory.contains(scannedData)) {
              setState(() {
                scanHistory.insert(0, scannedData);
              });
            }
          },
        ),
      ),
    )
        .then((_) {
      // Reset trạng thái khi quay lại
      isScanning = false;
    });
  }

  void _openHistoryScreen() {
    if (scanHistory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No scan history available!")),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryScreen(scanHistory: scanHistory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: IconButton(
              icon: const Icon(Icons.qr_code_scanner,
                  size: 80, color: Colors.blue),
              onPressed: _launchQRScanner,
            ),
          ),
          const SizedBox(height: 20),
          const Text("Tap to scan QR Code", style: TextStyle(fontSize: 18)),

          const SizedBox(height: 40),

          // Hiển thị nội dung của mã QR (nếu có)
          if (scanHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Scanned Data: ${scanHistory.first}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 20),
          // Nút "Open Browser" chỉ hiển thị nếu dữ liệu là URL hợp lệ
          if (scanHistory.isNotEmpty &&
              Uri.tryParse(scanHistory.first)?.hasAbsolutePath == true)
            ElevatedButton(
              onPressed: () => launchURL(scanHistory.first),
              child: const Text("Open Browser"),
            ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: _openHistoryScreen,
            child: const Text("History", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
