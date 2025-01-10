import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigita_online/models/adminModel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';


class KategoriDetailPage extends StatefulWidget {
  final String categoryId, judul;

  const KategoriDetailPage({Key? key, required this.categoryId, required this.judul}) : super(key: key);

  @override
  State<KategoriDetailPage> createState() => _KategoriDetailPageState();
}

class _KategoriDetailPageState extends State<KategoriDetailPage> {
  List<GetPostinganKategoriDetail> dataRespon = [];
  List<GetPostinganKategoriDetail> filteredDataRespon = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GetPostinganKategoriDetail.getPostinganKategoriDetail(widget.categoryId).then((value) {
      setState(() {
        dataRespon = value;
        filteredDataRespon = value;
      });
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredDataRespon = query.isEmpty
          ? dataRespon
          : dataRespon
              .where((item) =>
                  item.judul.toLowerCase().contains(query.toLowerCase()) ||
                  item.deskripsi.toLowerCase().contains(query.toLowerCase()) ||
                  item.kategori.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              child: pw.Text(
                'Laporan Postingan per Kategori ${widget.judul}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
                    'Tanggal Laporan: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.black,
                width: 1,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.5),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'No',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Kategori',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Judul',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Deskripsi',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Jumlah\nDownload',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Jumlah\nKomentar',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),

                // Table Data
                ...dataRespon.map((postingan) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            (dataRespon.indexOf(postingan) + 1).toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.kategori),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.file),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.deskripsi),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            postingan.jumlahDownload.toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            postingan.jumlahKomentar.toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ];
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/laporan_postingan.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Postingan Kategori', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromRGBO(202, 248, 253, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: TextField(
                controller: searchController,
                onChanged: filterSearchResults,
                decoration: InputDecoration(
                  hintText: "Cari Disini",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: const Icon(Icons.filter_list, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredDataRespon.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredDataRespon.length,
                      itemBuilder: (context, index) =>
                          _buildPostCard(filteredDataRespon[index]),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Color.fromRGBO(202, 248, 253, 1)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_emotions, size: 70),
                              SizedBox(height: 20),
                              Text(
                                "Maaf ya! Postingan Tidak Tersedia",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generatePDF,
        child: const Icon(Icons.picture_as_pdf, color: Colors.white),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildPostCard(GetPostinganKategoriDetail data) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              data.file,
              fit: BoxFit.cover,
              height: 140,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                "images/redContent.png",
                fit: BoxFit.cover,
                height: 140,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.judul,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  data.deskripsi,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.kategori,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      formatDate(data.tanggal),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.download_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      data.jumlahDownload,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.comment_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      data.jumlahKomentar,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}