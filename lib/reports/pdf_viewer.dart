import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share/share.dart' as sh;

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

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
      path: path,
    );
  }

  _onClickShare(){
    var file = File(path);
    sh.Share.shareFiles([file.path], text: 'Great picture');
  }



}
