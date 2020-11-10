import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share/share.dart' as sh;

class PdfViewerPage extends StatefulWidget {
  final String path;
  bool isLandscape;

  PdfViewerPage({this.path, this.isLandscape = false});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  @override
  void initState() {
    if(widget.isLandscape)
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text('Documento'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _onClickShare
          ),
        ],
      ),
      path: widget.path,
    );
  }

  _onClickShare(){
    var file = File(widget.path);
    sh.Share.shareFiles([file.path], text: 'Segue o relatório');
  }
}
