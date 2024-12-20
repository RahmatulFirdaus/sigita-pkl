import 'package:flutter/material.dart';
import 'package:sigita_online/models/adminModel.dart';

class EditKategori extends StatefulWidget {
  String id;
  EditKategori({super.key, required this.id});

  @override
  State<EditKategori> createState() => _EditKategoriState();
}

class _EditKategoriState extends State<EditKategori> {
  TextEditingController kategoriController = TextEditingController();
  List<GetKategoriAdminDetail> getKategoriAdmin = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final user = await GetKategoriAdminDetail.getKategoriAdminDetail(widget.id);
    setState(() {
      kategoriController.text = user.kategori;
    });
  }

  void updateData() async {
    try {
      await UpdateKategoriAdmin.updateKategoriAdmin(
          widget.id, kategoriController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Berhasil Tersimpan")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat menyimpan data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Kategori"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Text(
                    "Kategori",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: kategoriController,
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
                        onPressed: () async {
                          updateData();
                        },
                        child: const Text("Simpan"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
