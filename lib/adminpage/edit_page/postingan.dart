import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:sigita_online/models/sigitaModel.dart';

class UpdatePostingan extends StatefulWidget {
  final String id;
  const UpdatePostingan({super.key, required this.id});

  @override
  State<UpdatePostingan> createState() => _UpdatePostinganState();
}

class _UpdatePostinganState extends State<UpdatePostingan> {
  TextEditingController judulController = TextEditingController();
  TextEditingController fileController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  String? idKategori;
  List<GetKategori> dataKategori = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  File? _file;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPostinganDetail(widget.id);
    loadData();
  }

  void fetchData() async {
    final getKategoriFetch = await GetKategori.getKategori();
    setState(() {
      dataKategori = getKategoriFetch;
    });
  }
  void loadData() async {
    try {
      final user = await GetSigita.connApiDetail(widget.id);
      setState(() {
        judulController.text = user.title.toString();
        fileController.text = user.file.toString();
        deskripsiController.text = user.content.toString();
        tanggalController.text = user.date.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchPostinganDetail(String id) async {
    final response = await http.get(
      Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getPostinganDetail/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        judulController.text = data['judul'] ?? '';
        deskripsiController.text = data['deskripsi'] ?? '';
        tanggalController.text = data['tanggal'] ?? '';
        fileController.text = data['file'] ?? '';
      });
    } else {
      print("Failed to fetch post detail.");
    }
  }

  Future<String> _generateFileName(File file) async {
    Uint8List fileBytes = await file.readAsBytes();
    Digest hash = md5.convert(fileBytes);
    return hash.toString();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _file = File(result.files.single.path!);
      String newFileName = await _generateFileName(_file!);
      setState(() {
        fileController.text = newFileName;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          tanggalController.text =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
        });
      }
    }
  }

  Future<void> updatePostingan({
  required String id,
  required String id_kategori,
  required String judul,
  required String deskripsi,
  required String tanggal,
}) async {
  var uri = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/updatePostingan/$id");
  var request = http.MultipartRequest('PATCH', uri);

  if (_file != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _file!.path,
        filename: fileController.text,
      ),
    );
  } else {
    print("File tidak boleh kosong.");
    return;
  }

  request.fields['judul'] = judul;
  request.fields['id_kategori'] = id_kategori;
  request.fields['deskripsi'] = deskripsi;
  request.fields['tanggal'] = tanggal;

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    print("Data updated successfully: $responseBody");
  } else {
    var responseBody = await response.stream.bytesToString();
    print("Failed to update data. Status: ${response.statusCode}, Response: $responseBody");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Update Postingan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(
                  title: "Judul Postingan",
                  child: TextFormField(
                    controller: judulController,
                    decoration: _buildInputDecoration(
                      hintText: "Masukkan judul postingan",
                      prefixIcon: Icons.title,
                    ),
                  ),
                ),
                _buildInputSection(
                  title: "Kategori",
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: idKategori,
                        hint: const Text("Pilih kategori postingan"),
                        items: dataKategori.map((GetKategori getKategori) {
                          return DropdownMenuItem<String>(
                            value: getKategori.id,
                            child: Text(getKategori.kategori),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            idKategori = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                _buildInputSection(
                  title: "Upload File",
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fileController,
                        readOnly: true,
                        decoration: _buildInputDecoration(
                          hintText: _file != null
                              ? basename(_file!.path)
                              : "Pilih file untuk diunggah",
                          prefixIcon: Icons.attachment,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Pilih File"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInputSection(
                  title: "Deskripsi",
                  child: TextFormField(
                    controller: deskripsiController,
                    maxLines: 4,
                    decoration: _buildInputDecoration(
                      hintText: "Tuliskan deskripsi postingan",
                      prefixIcon: Icons.description,
                    ),
                  ),
                ),
                _buildInputSection(
                  title: "Tanggal",
                  child: TextFormField(
                    controller: tanggalController,
                    readOnly: true,
                    decoration: _buildInputDecoration(
                      hintText: "Pilih tanggal postingan",
                      prefixIcon: Icons.calendar_today,
                    ),
                    onTap: () => _selectDateTime(context),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await updatePostingan(
                              id: widget.id,
                              id_kategori: idKategori!,
                              judul: judulController.text,
                              deskripsi: deskripsiController.text,
                              tanggal: tanggalController.text,
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            _showErrorMessage(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(prefixIcon, color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text("Data berhasil diperbarui"),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text("Gagal memperbarui data"),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
