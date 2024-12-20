import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigita_online/models/adminModel.dart';

class KategoriDetailPage extends StatefulWidget {
  final String categoryId;

  const KategoriDetailPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<KategoriDetailPage> createState() => _KategoriDetailPageState();
}

class _KategoriDetailPageState extends State<KategoriDetailPage> {
  late Future<List<GetPostinganKategoriDetail>> _postings;

  @override
  void initState() {
    super.initState();
    _postings = GetPostinganKategoriDetail.getPostinganKategoriDetail(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Detail Kategori',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<GetPostinganKategoriDetail>>(
        future: _postings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada postingan'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Container
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        image: DecorationImage(
                          image: NetworkImage(post.file),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            post.judul,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Category & Date
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  post.kategori,
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(post.tanggal)),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Description
                          Text(
                            post.deskripsi,
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          
                          // Stats Row
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.download, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post.jumlahDownload} Downloads',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.comment, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post.jumlahKomentar} Comments',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
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
        },
      ),
    );
  }
}