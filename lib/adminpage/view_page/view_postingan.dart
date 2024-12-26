import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

import 'package:sigita_online/models/adminModel.dart';
import 'package:sigita_online/models/sigitaModel.dart'; // Adjust import as needed

class ViewPostinganPage extends StatefulWidget {
  final String id, judul;
  const ViewPostinganPage({super.key, required this.id, required this.judul});

  @override
  State<ViewPostinganPage> createState() => _ViewPostinganPageState();
}

class _ViewPostinganPageState extends State<ViewPostinganPage> {
  List<GetViewKomentar> komentarList = [];
  GetSigita postinganList = GetSigita(
    id: '',
    title: '',
    content: '',
    date: '',
    category: '',
    jumlah: '',
    file: '',
    idKategori: '',
  );
  bool _isExporting = false;

  // Function to generate a color based on nama
  Color _generateColorFromnama(String nama) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFFFEEAD),
    ];
    final index = nama.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final ambilData = await GetSigita.connApiDetail(widget.id);
    setState(() {
      postinganList = ambilData;
    });
  }

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(date));
  }

  // PDF Export Function
  Future<void> _exportToPdf(List<GetViewKomentar> comments) async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Create PDF Document
      final pdf = pw.Document();

      // Add Page
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      'Komentar Postingan: ${widget.judul} (${comments.length} Komentar)',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Tanggal Postingan: ${formatDate(postinganList.date)}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Text(
                    'Tanggal Laporan: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey600,
                      width: 0.5,
                    ),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(40),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FixedColumnWidth(90),
                      3: const pw.FixedColumnWidth(100),
                      4: const pw.FlexColumnWidth(3),
                      5: const pw.FixedColumnWidth(90),
                    },
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColors.grey600,
                              width: 1,
                            ),
                          ),
                        ),
                        children: [
                          'No',
                          'Nama',
                          'Kode Perawat',
                          'No Telpon',
                          'Komentar',
                          'Tanggal',
                        ]
                            .map((text) => pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 8,
                                  ),
                                  child: pw.Text(
                                    text,
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      ...comments.asMap().entries.map((entry) {
                        int index = entry.key;
                        GetViewKomentar comment = entry.value;

                        return pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: index.isEven
                                ? PdfColors.white
                                : PdfColors.grey100,
                          ),
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                '${index + 1}',
                                textAlign: pw.TextAlign.center,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                comment.nama,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                comment.kodePerawat,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                comment.phone,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                comment.komentar,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              child: pw.Text(
                                formatDate(comment.tanggal),
                                textAlign: pw.TextAlign.center,
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      // Save PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/komentar_postingan.pdf');
      await file.writeAsBytes(await pdf.save());

      // Show Success Snackbar and Open File
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF berhasil dibuat'),
          backgroundColor: Colors.green,
        ),
      );

      // Open the PDF
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF1E1E2A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Komentar Postingan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
              onPressed: () async {
                // Fetch comments and export to PDF
                final comments =
                    await GetViewKomentar.getViewKomentar(widget.id);
                if (comments.isNotEmpty) {
                  _exportToPdf(comments);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada komentar untuk diekspor'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<GetViewKomentar>>(
          future: GetViewKomentar.getViewKomentar(widget.id),
          builder: (context, snapshot) {
            if (_isExporting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada komentar ditemukan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final komentar = snapshot.data!;
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: komentar.length,
                itemBuilder: (context, index) {
                  final item = komentar[index];
                  final userColor = _generateColorFromnama(item.nama);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            Icons.comment_rounded,
                            size: 100,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          userColor,
                                          userColor.withOpacity(0.6),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: userColor.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // User info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nama,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              item.kodePerawat,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              item.phone,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              formatDate(item.tanggal),
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item.komentar,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
