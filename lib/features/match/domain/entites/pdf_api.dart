import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:scouting_tracker_beach_volley/features/match/domain/entites/match.dart';

class PdfApi {
  static Future<File> generateMatchStatic(AMatch match) async {
    final pdf = Document();
    final font =
        await rootBundle.load("lib/core/assets/fonts/Roboto-Black.ttf");
    final ttf = Font.ttf(font);
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
            child: Text(match.description,
                style: TextStyle(font: ttf, fontSize: 40)),
          ); // Center
        },
      ),
    );

    return PdfApi.saveDocument(name: "statistics.pdf", document: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document document,
  }) async {
    final bytes = await document.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    final contents = await file.readAsBytes();
    print('File saved at: ${file.path}');

    print('File contents: $contents');

    print("save document ");
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print("Opening $url");
    try {
      await OpenFile.open(url);
      print("opend");

    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
