import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:create_pdf/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_filex/open_filex.dart' as op;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static void downloadingPdf({
    required ByteData img,
    required String date,
    required String regNo,
    required num rentPerDay,
    required num days,
    required String driverName,
  }) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      final initialStatus = await Permission.storage.status;
      if (initialStatus.isPermanentlyDenied) {
        AppSettings.openAppSettings();
      }
    }

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus != PermissionStatus.granted) {
      return;
    }
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final imageBytes = img.buffer.asUint8List();
          return [
            pw.Container(
              margin: const pw.EdgeInsets.only(left: 20, right: 0),
              child: pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(16, 30, 0, 30),
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(
                          children: [
                            pw.ClipRRect(
                                verticalRadius: 250,
                                horizontalRadius: 250,
                                child: pw.Image(
                                  pw.MemoryImage(
                                    imageBytes,
                                  ),
                                  fit: pw.BoxFit.contain,
                                  height: 50,
                                  width: 35,
                                )),
                            pw.SizedBox(
                              width: 10,
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Company',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  'company.com',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex('808080'),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(
                            date,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 20,
                    ),
                    pw.Container(
                      height: 5,
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(2),
                        color: PdfColor.fromHex('808080'),
                      ),
                    ),
                    pw.SizedBox(
                      height: 30,
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Vehicle Reg No',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromHex('808080'),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                regNo,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(
                            height: 16,
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Name',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromHex('808080'),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                driverName,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(
                            height: 16,
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Rent Per Day',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromHex('808080'),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '$rentPerDay EUR',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(
                            height: 16,
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Days',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromHex('808080'),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                days.toString(),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 30,
                    ),
                    pw.Divider(
                      height: 1,
                      color: PdfColor.fromHex('808080'),
                    ),
                    pw.SizedBox(
                      height: 30,
                    ),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                        child: pw.Column(
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                '${days * rentPerDay} EUR',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.SizedBox(
                              height: 60,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Icon(
                                  const pw.IconData(169),
                                  color: PdfColor.fromHex('808080'),
                                  size: 12,
                                ),
                                pw.SizedBox(
                                  width: 2,
                                ),
                                pw.Text(
                                  'copyright company.com. All Rights Reserved.',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex('808080'),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Support at ',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex('808080'),
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    'www.company.com',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      color: PdfColor.fromHex('1c5ecc'),
                                      decoration: pw.TextDecoration.underline,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ])
                          ],
                        ))
                  ],
                ),
              ),
            )
          ];
        }));

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${const Uuid().v4()}.pdf';

    try {
      await File(path).writeAsBytes(await pdf.save());

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'pdf_channel',
        'PDF Notifications',
        channelDescription: 'Channel for PDF open notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Your pdf is ready',
        'Tap to view the PDF file',

        platformChannelSpecifics,
        payload: path, // Pass the path as payload
      );
    } catch (e) {
      log('error $e');
      showSnackBar('Pdf not download.');
    }
  }
}

void showSnackBar(String content) {
  Get.showSnackbar(GetSnackBar(
    messageText: Text(
      content,
      style: GoogleFonts.poppins(
          fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: Colors.grey[700]!,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: 10,
    // key: const Key('successSnackbar'),
    icon: null,
  ));
}

TextStyle get14Light() {
  return GoogleFonts.poppins(
    height: 1.17,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );
}

String minErrorString(String field, String chars) {
  return '$field minimum length is $chars characters';
}

String maxErrorString(String field, String chars) {
  return '$field maximum length is $chars characters';
}

class ApplicationTheme {
  ThemeData themeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          surface: Colors.white,
          surfaceTint: Colors.white,
          primary: Colors.orange,
          seedColor: Colors.orange),
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500)))),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[400],
          height: 1.17,
          letterSpacing: -.2,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
        fillColor: const Color(0xffF8F7FE),
        filled: true,
        suffixIconColor: Colors.orange,
        errorStyle: GoogleFonts.poppins(
          color: Colors.red,
          height: 1.17,
          fontWeight: FontWeight.w300,
          letterSpacing: -.2,
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent)),
      ),
    );
  }
}
