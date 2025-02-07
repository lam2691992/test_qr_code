import 'package:flutter/material.dart';
import 'package:qr_scanner/screen/qr_scanner_screen.dart';

import '../utils/url_launcher.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> scanHistory;

  const HistoryScreen({super.key, required this.scanHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "History",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: scanHistory.isEmpty
          ? const Center(
              child: Text(
              "No Data",
              style: TextStyle(fontSize: 18),
            ))
          : ListView.builder(
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scanHistory[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    onPressed: () => launchURL(scanHistory[index]),
                  ),
                );
              },
            ),
    );
  }
}
