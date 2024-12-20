import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Viewpdfpage extends StatefulWidget {
  var data;
  Viewpdfpage({super.key, required this.data});

  @override
  State<Viewpdfpage> createState() => _ViewpdfpageState();
}

class _ViewpdfpageState extends State<Viewpdfpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Back"),
      ),
      body: Container(child: SfPdfViewer.network("${widget.data}")),
    );
  }
}
