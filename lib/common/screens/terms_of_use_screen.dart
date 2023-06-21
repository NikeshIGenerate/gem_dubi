import 'package:flutter/material.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Terms of usage')),
      body: SfPdfViewer.asset(
        R.ASSETS_PDF_TERMS_USAGE_PDF,
        pageSpacing: 0,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        canShowHyperlinkDialog: false,
        canShowPaginationDialog: false,
        canShowPasswordDialog: false,
      ),
    );
  }
}
