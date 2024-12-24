import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

import 'package:sigita_online/models/adminModel.dart'; // Adjust import as needed

class ViewDownload extends StatefulWidget {
  final String id;
  const ViewDownload({super.key, required this.id});

  @override
  State<ViewDownload> createState() => _ViewDownloadState();
}

class _ViewDownloadState extends State<ViewDownload> {
  List<GetViewDownload> downloads = [];
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

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(date));
  }

  // PDF Export Function
  Future<void> _exportToPdf(List<GetViewDownload> downloads) async {
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
                'Riwayat Download',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
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
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'No',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Nama',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Kode Perawat',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Phone',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Tanggal Download',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Table Rows
                ...downloads.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    GetViewDownload download = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${index + 1}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(download.nama),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(download.kodePerawat),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(download.phone),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(formatDate(download.tanggal)),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ],
        ),
      );

      // Save PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/riwayat_download.pdf');
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Riwayat Download',
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
                // Fetch downloads and export to PDF
                final downloads =
                    await GetViewDownload.getViewDownload(widget.id);
                if (downloads.isNotEmpty) {
                  _exportToPdf(downloads);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada data untuk diekspor'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<GetViewDownload>>(
          future: GetViewDownload.getViewDownload(widget.id),
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
                      Icons.download_outlined,
                      color: Colors.grey,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada riwayat download',
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
              final downloads = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: downloads.length,
                itemBuilder: (context, index) {
                  final item = downloads[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            Icons.download_rounded,
                            size: 100,
                            color: Colors.cyan.withOpacity(0.05),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item.kodePerawat,
                                      style: const TextStyle(
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    formatDate(item.tanggal),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.nama,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.phone,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
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
                },
              );
            }
          },
        ),
      ),
    );
  }
}
