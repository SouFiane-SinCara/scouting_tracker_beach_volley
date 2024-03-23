import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/widgets/field_volley.dart';

import 'package:screenshot/screenshot.dart';

class PdfStatistics extends StatelessWidget {
  const PdfStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final screenshotController = ScreenshotController();

    Size size = device(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: InkWell(
              onTap: () async {
                final pdf = pw.Document();

                final image = pw.MemoryImage(
                  (await screenshotController.capture())!.buffer.asUint8List(),
                );

                pdf.addPage(pw.Page(
                  build: (pw.Context context) => pw.Center(
                    child: pw.Image(image),
                  ),
                ));

                final output = await getTemporaryDirectory();
                final file = File('${output.path}/example.pdf');
                await file.writeAsBytes(await pdf.save());

                Printing.sharePdf(
                    bytes: await pdf.save(), filename: 'example.pdf');
              },
              child: Text('Generate PDF'))),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 300,
                    height: 150,
                    color: Colors.amber,
                    child: VolleyballField(
                      isShowStatics: true,
                    )),
                    SizedBox(height: size.height,),
                Container(
                  width: size.width,
                  color: Colors.green,
                  height: size.height * 0.2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
