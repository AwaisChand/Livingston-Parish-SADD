import 'dart:io';

import 'package:dp_sad/models/resource_detail_model/resource_detail_model.dart';
import 'package:dp_sad/repository/resource_detail_repository/resource_detail_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../utils/utils.dart';

class ResourceDetailViewModel extends ChangeNotifier {
  final ResourceDetailRepository authRepository = ResourceDetailRepository();

  List<Resources>? _resource;
  List<Resources>? get resource => _resource;

  bool _resourceDetailLoading = false;
  bool get resourceDetailLoading => _resourceDetailLoading;

  set resourceLoading(bool setLoading) {
    _resourceDetailLoading = setLoading;
    notifyListeners();
  }

  Future<void> resourceDetailApi(BuildContext context) async {
    resourceLoading = true; // This already calls notifyListeners

    try {
      final response = await authRepository.resourceDetail();

      if (response.status == "1") {
        _resource = response.data?.resources;
        Utils.toastMessage(response.message ?? '');
      } else {
        Utils.toastMessage(response.message ?? '');
      }

      if (kDebugMode) {
        debugPrint("Get Resource Detail API Response: $response");
      }
    } catch (e) {
      debugPrint("Resource Detail error: $e");
      Utils.toastMessage("Error: ${e.toString()}");
    } finally {
      resourceLoading = false; // Again, setter calls notifyListeners
    }
  }

  Future<void> downloadPdf({
    required BuildContext context,
    required String title,
    required String keywords,
    required String content,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Resource Details",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Title: $title"),
              pw.SizedBox(height: 10),
              pw.Text("Keywords: $keywords"),
              pw.SizedBox(height: 10),
              pw.Text("Content: $content"),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getTemporaryDirectory(); // or getApplicationDocumentsDirectory()
      final file = File("${directory.path}/resource_details.pdf");

      await file.writeAsBytes(await pdf.save());

      // Open the file
      await OpenFile.open(file.path);

      Utils.toastMessage("PDF Downloaded Successfully");
    } catch (e) {
      Utils.toastMessage("PDF download failed: ${e.toString()}");
      if (kDebugMode) debugPrint("PDF Error: $e");
    }
  }

}
