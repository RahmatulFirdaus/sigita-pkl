import 'package:flutter/material.dart';
import 'package:sigita_online/models/adminModel.dart';
import 'package:sigita_online/models/sigitaModel.dart';

class UpdatePostingan extends StatefulWidget {
  final String id;
  const UpdatePostingan({super.key, required this.id});

  @override
  State<UpdatePostingan> createState() => _UpdatePostinganState();
}

class _UpdatePostinganState extends State<UpdatePostingan> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  GetSigita? getSigitaList;

  @override
  void initState() {
    super.initState();
    fetchData();
    loadData();
  }

  void fetchData() async {
    final ambilData = await GetSigita.connApiDetail(widget.id);
    setState(() {
      getSigitaList = ambilData;
    });
  }

  void updateData() async {
    try {
      await UpdatePostinganAdmin.updatePostinganAdmin(
        widget.id,
        judulController.text,
        fileController.text,
        deskripsiController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Berhasil Tersimpan")),
      );
      Navigator.pop(context);
    } catch (e) {
      // Menangani kesalahan saat memperbarui data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat menyimpan data: $e")),
      );
    }
  }

  void loadData() async {
    try {
      final user = await GetSigita.connApiDetail(widget.id);
      setState(() {
        judulController.text = user.title.toString();
        fileController.text = user.file.toString();
        deskripsiController.text = user.content.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when not needed to free up resources
    judulController.dispose();
    fileController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Edit Postingan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Field
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Text(
                  "Judul",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Text(
                  "File",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: fileController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundColor: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 131, 255, 135),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        updateData();
                      },
                      child: const Text("Update"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
