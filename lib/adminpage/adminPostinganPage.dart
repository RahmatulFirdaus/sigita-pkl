import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigita_online/adminpage/edit_page/postingan.dart';
import 'package:sigita_online/adminpage/tambah_page/tambah_postingan.dart';
import 'package:sigita_online/adminpage/view_page/view_menu.dart';
import 'package:sigita_online/models/adminModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class Adminpostinganpage extends StatefulWidget {
  const Adminpostinganpage({super.key});

  @override
  State<Adminpostinganpage> createState() => _AdminpostinganpageState();
}

class _AdminpostinganpageState extends State<Adminpostinganpage> {
  List<GetPostinganAdmin> getPostingan = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final getPosting = await GetPostinganAdmin.getPostinganAdmin();
      setState(() {
        getPostingan = getPosting;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  List<GetPostinganAdmin> get filteredPostingan => getPostingan
      .where((post) =>
          post.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          post.category.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
              child: pw.Text(
                'Laporan Postingan',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
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
                        'File',
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
                ...getPostingan.map((postingan) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            (getPostingan.indexOf(postingan) + 1).toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.category),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.file),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(postingan.content),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Postingan Management',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.blue[900]!,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.article_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                tooltip: 'Tambah Postingan',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPostingan()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Refresh Data',
                onPressed: fetchData,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                setState(() => searchQuery = value),
                            decoration: InputDecoration(
                              hintText: 'Cari postingan...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${filteredPostingan.length} postingan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          cardTheme: CardTheme(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: PaginatedDataTable(
                          header: null,
                          columns: const [
                            DataColumn(
                              label: Text(
                                "No",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Judul",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Kategori",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "File",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Deskripsi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Downloads",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Komentar",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Tanggal",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Aksi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          source: MyDataSource(
                            getPostingan: filteredPostingan,
                            context: context,
                            onRefresh: fetchData,
                          ),
                          rowsPerPage: 10,
                          showFirstLastButtons: true,
                          arrowHeadColor: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: generatePDF,
        child: const Icon(Icons.picture_as_pdf, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<GetPostinganAdmin> getPostingan;
  final BuildContext context;
  final Function onRefresh;

  MyDataSource({
    required this.getPostingan,
    required this.context,
    required this.onRefresh,
  });

  String formatDate(String date) {
    return DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(date));
  }

  @override
  DataRow? getRow(int index) {
    if (index >= getPostingan.length) return null;

    final postingan = getPostingan[index];

    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(Text(postingan.title)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              postingan.category,
              style: TextStyle(color: Colors.blue[700]),
            ),
          ),
        ),
        DataCell(Text(postingan.file)),
        DataCell(Text(postingan.content)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              postingan.jumlahDownload.toString(),
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              postingan.jumlahKomentar.toString(),
              style: TextStyle(color: Colors.orange[700]),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              formatDate(postingan.date).toString(),
              style: TextStyle(color: Colors.orange[700]),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.yellow[700]),
                tooltip: 'View Postingan',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewMenu(
                        postId: postingan.id,
                        judul: postingan.title,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[700]),
                tooltip: 'Edit Postingan',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePostingan(id: postingan.id),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[700]),
                tooltip: 'Hapus Postingan',
                onPressed: () => _showDeleteDialog(context, postingan),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, GetPostinganAdmin postingan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
            onPressed: () async {
              try {
                await DeletePostinganAdmin.deletePostinganAdmin(postingan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Postingan berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
                await onRefresh();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => getPostingan.length;

  @override
  int get selectedRowCount => 0;
}
