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
  List<GetSigita> postinganList = [];
  bool _isExporting = false;

  // Function to generate a color based on nama
  Color _generateColorFromnama(String nama) {
    int hash = nama.hashCode;
    return Color.fromRGBO(
      (hash & 0xFF0000) >> 16,
      (hash & 0x00FF00) >> 8,
      hash & 0x0000FF,
      0.7,
    );
  }

  void fetchData() async {
    final ambilData = await GetSigita.connApi(widget.id);
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
            pw.Text(
              'Tanggal Postingan: ${formatDate(postinganList[0].date)}',
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey,
              ),
            ),
            pw.Text(
              'Tanggal Laporan: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey,
              ),
            ),
            pw.SizedBox(height: 16), // Spasi tambahan antara header dan tabel
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(50), // No column
                1: const pw.FlexColumnWidth(2), // nama column
                2: const pw.FixedColumnWidth(100), // Date column
                3: const pw.FlexColumnWidth(3), // Comment column
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'No',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Nama',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Kode Perawat',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'No Telpon',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Komentar',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Tanggal',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Table Rows
                ...comments.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    GetViewKomentar comment = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '${index + 1}',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            comment.nama,
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            comment.kodePerawat,
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            comment.phone,
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            comment.komentar,
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            formatDate(comment.tanggal),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
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
      // Show Error Snackbar
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
        backgroundColor: const Color(0xFF1E1E2A),
        appBar: AppBar(
          title: const Text(
            'Komentar Postingan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              onPressed: () async {
                // Fetch comments and export to PDF
                final comments = await GetViewKomentar.getViewKomentar(widget.id);
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
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: komentar.length,
                itemBuilder: (context, index) {
                  final item = komentar[index];
                  final userColor = _generateColorFromnama(item.nama);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2C2C3E).withOpacity(0.7),
                          const Color(0xFF1E1E2A).withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Person Icon with Unique Color
                                  Container(
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
                                          color: userColor.withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.only(right: 16),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.person_outline,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      item.nama,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.cyan,
                                        letterSpacing: 1.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item.kodePerawat,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    item.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formatDate(item.tanggal),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.komentar,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
