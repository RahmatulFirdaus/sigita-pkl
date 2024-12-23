import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigita_online/models/sigitaModel.dart';
import 'package:sigita_online/navigasi/navigasiBar.dart';
import 'package:sigita_online/pages/view.dart';
import 'package:url_launcher/url_launcher.dart';

class PageProposal extends StatefulWidget {
  final String id;
  const PageProposal({super.key, required this.id});

  @override
  State<PageProposal> createState() => _PageProposalState();
}

class _PageProposalState extends State<PageProposal> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _downloadnamaController = TextEditingController();

  GetSigita dataRespon = GetSigita(
      id: "",
      title: "",
      content: "",
      file: "",
      date: "",
      category: "",
      jumlah: "",
      idKategori: "");
  GetFile dataFile = GetFile(pdf: "");
  GetUser getUser =
      GetUser(id: "", userId: "", nama: "", kodePerawat: "", phone: "");
  List<GetKomentar> dataKomentar = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final responData = await GetSigita.connApiDetail(widget.id);
      final fileData = await GetFile.getFile(widget.id);
      final komentarData = await GetKomentar.getKomentar(widget.id);
      final userData = await GetUser.getUser();

      setState(() {
        dataRespon = responData;
        dataFile = fileData;
        dataKomentar = komentarData;
        getUser = userData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _submitComment() async {
    try {
      if (_commentController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("nama dan Komentar harus diisi")),
        );
        return;
      }

      await PostSigita.postSigita(
          widget.id, getUser.id, _commentController.text);

      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Komentar Berhasil Dimasukkan")),
      );

      // Optional: Clear text fields after submission
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat menyimpan data: $e")),
      );
    }
  }

  void downloadPDF() async {
    await PermissionFile.postDownload(widget.id, getUser.id);
    launchUrl(Uri.parse(dataFile.pdf));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Navigasibar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildInfoRow(),
                  const SizedBox(height: 16),
                  _buildDescription(),
                  const SizedBox(height: 16),
                  _buildCommentSection(),
                  const SizedBox(height: 16),
                  _buildDownloadSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      dataRespon.title,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoColumn(Icons.date_range, dataRespon.date, 'Tanggal'),
        _buildInfoColumn(Icons.book, dataRespon.category, 'Kategori'),
        _buildInfoColumn(Icons.accessibility_new, dataRespon.jumlah, 'Jumlah'),
      ],
    );
  }

  Widget _buildInfoColumn(IconData icon, String text, String label) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      dataRespon.content,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Komentar',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            color: Colors.white,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Komentar',
                      prefixIcon: const Icon(Icons.comment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitComment,
                    child: const Text('Kirim Komentar'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCommentList(),
      ],
    );
  }

  Widget _buildCommentList() {
    return dataKomentar.isEmpty
        ? const Center(child: Text('Belum Ada Komentar'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataKomentar.length,
            itemBuilder: (context, index) {
              var comment = dataKomentar[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  "${comment.kode_perawat} ${comment.nama}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(comment.komentar ?? ''),
              );
            },
          );
  }

  Widget _buildDownloadSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Informasi Lebih Lanjut',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue),
                    onPressed: () {
                      downloadPDF();
                    },
                    child: const Text('Download PDF'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Viewpdfpage(
                            data: dataFile.pdf,
                          ),
                        ),
                      );
                    },
                    child: const Text('Lihat PDF'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
