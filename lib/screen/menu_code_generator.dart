import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner/screen/text_generator_screen.dart';
import 'package:qr_scanner/screen/web_generator_screen.dart';
import 'barcode_generator_screen.dart';

class CodeGeneratorScreen extends StatelessWidget {
  const CodeGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các mục, không thay đổi thứ tự hay nhóm theo hàng
    final List<Map<String, dynamic>> categories = [
      {"title": "Barcode", "isHeader": true},
      {"title": "Barcode", "icon": Icons.qr_code, "color": Colors.purple},
      {"title": "General", "isHeader": true},
      {"title": "Text", "icon": Icons.edit, "color": Colors.orange},
      {"title": "Wifi", "icon": Icons.wifi, "color": Colors.teal},
      {"title": "App Store", "icon": Icons.apple, "color": Colors.black},
      {"title": "Communication", "isHeader": true},
      {"title": "Phone", "icon": Icons.phone, "color": Colors.pink},
      {"title": "Email", "icon": Icons.email, "color": Colors.red},
      {"title": "Social", "isHeader": true},
      {
        "title": "Facebook",
        "icon": Icons.facebook,
        "color": Colors.blue.shade800
      },
      {
        "title": "Pinterest",
        "icon": 'asset/pinterest.svg',
      },
      {"title": "Media", "isHeader": true},
      {
        "title": "Youtube",
        "icon": 'asset/youtube.svg',
      },
      {
        "title": "Soundcloud",
        "icon": 'asset/soundcloud.svg',
      },
      {"title": "Cloud", "isHeader": true},
      {"title": "Drive", "icon": 'asset/drive.svg'},
      // {"title": "iCloud", "icon": 'asset/icloud.png'},
      {"title": "Dropbox", "icon": 'asset/dropbox.svg'},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.orange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(color: Colors.orange, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "Code Generator",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: categories.map<Widget>((category) {
            if (category['isHeader'] == true) {
              return _buildHeader(category['title']);
            } else if (category['title'] == "Text") {
              // Nhóm "Text" và "Website" thành 1 hàng
              return _buildRow(
                context,
                category,
                {
                  "title": "Website",
                  "icon": Icons.language,
                  "color": Colors.green,
                },
              );
            } else if (category['title'] == "Wifi") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Location",
                  "icon": Icons.location_on,
                  "color": Colors.blue,
                },
              );
            } else if (category['title'] == "Facebook") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Instagram",
                  "icon": 'asset/instagram.png',
                },
              );
            } else if (category['title'] == "Phone") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Message",
                  "icon": Icons.message,
                  "color": Colors.deepPurple,
                },
              );
            } else if (category['title'] == "Pinterest") {
              return _buildRow(
                context,
                category,
                {
                  "title": "WhatsApp",
                  "icon": 'asset/whatsapp.svg',
                },
              );
            } else if (category['title'] == "Youtube") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Spotify",
                  "icon": 'asset/spotify.svg',
                },
              );
            } else if (category['title'] == "Drive") {
              return _buildRow(
                context,
                category,
                {
                  "title": "iCloud",
                  "icon": 'asset/icloud.png',
                },
              );
            } else if (category['title'] == "Soundcloud") {
              return _buildRow(
                context,
                category,
                {
                  "title": "Music",
                  "icon": Icons.music_note_rounded,
                  "color": Colors.pink,
                },
              );
            } else {
              return buildCategoryCard(context, category);
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> leftItem,
      Map<String, dynamic> rightItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: buildCategoryCard(context, leftItem)),
          const SizedBox(width: 10),
          Expanded(child: buildCategoryCard(context, rightItem)),
        ],
      ),
    );
  }

  Widget buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    bool isSmallCard = category['title'] == "Email" ||
        category['title'] == "Barcode" ||
        category['title'] == "Dropbox" ||
        category['title'] == "App Store";
    double cardWidthFactor = isSmallCard ? 0.5 : 1.0;

    Widget iconWidget;
    if (category['icon'] is String) {
      if (category['icon'].toString().endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          category['icon'],
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        );
      } else {
        iconWidget = Image.asset(
          category['icon'],
          width: 30,
          height: 30,
        );
      }
    } else if (category['icon'] is IconData) {
      iconWidget = Icon(
        category['icon'],
        color: category['color'],
        size: 30,
      );
    } else {
      iconWidget = const SizedBox();
    }

    Widget cardWidget = GestureDetector(
      onTap: () {
        // Điều hướng theo tiêu đề của mục
        if (category['title'] == "Barcode") {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BarcodeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        } else if (category['title'] == "Text") {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const TextScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        } else if (category['title'] == "Website") {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const WebScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: FractionallySizedBox(
        widthFactor: cardWidthFactor,
        child: Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: 10),
                Text(
                  category['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isSmallCard) {
      return Align(
        alignment: Alignment.centerLeft,
        child: cardWidget,
      );
    }
    return cardWidget;
  }
}
