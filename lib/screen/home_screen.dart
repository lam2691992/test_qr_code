import 'package:flutter/material.dart';
import 'package:qr_scanner/screen/qr_scanner_screen.dart';
import 'package:qr_scanner/database/database_helper.dart';
import '../utils/url_launcher.dart';
import 'menu_code_generator.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> scanHistory = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    final history = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      scanHistory = history;
    });
  }

  // Mở màn hình quét QR, sau khi quét xong lưu dữ liệu vào database và reload danh sách.
  void _launchQRScanner() {
    if (isScanning) return; // Ngăn mở nhiều lần

    isScanning = true;
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onQRScanned: (String scannedData) async {
            // Lưu dữ liệu quét
            await DatabaseHelper.instance.insert({
              DatabaseHelper.columnScanData: scannedData,
              DatabaseHelper.columnTimestamp:
                  DateTime.now().millisecondsSinceEpoch,
            });
            // Reload lịch sử quét từ database
            await _loadScanHistory();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Scan saved: $scannedData")),
            );
          },
        ),
      ),
    )
        .then((_) {
      isScanning = false;
    });
  }

  // Mở màn hình HistoryScreen nếu có lịch sử quét, nếu không hiển thị SnackBar thông báo.
  void _openHistoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            HistoryScreen(scanHistory: scanHistory), // Truyền scanHistory
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu của mã QR mới nhất nếu có
    String? firstScanData;
    if (scanHistory.isNotEmpty) {
      firstScanData = scanHistory.first[DatabaseHelper.columnScanData];
    }

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
          // Hiển thị nội dung của mã QR mới nhất (nếu có)
          if (firstScanData != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Scanned Data: $firstScanData",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
          if (firstScanData != null &&
              Uri.tryParse(firstScanData)?.hasAbsolutePath == true)
            ElevatedButton(
              onPressed: () => launchURL(firstScanData!),
              child: const Text("Open Browser"),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _openHistoryScreen,
                child: const Text("History", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      // animation
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const CodeGeneratorScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
