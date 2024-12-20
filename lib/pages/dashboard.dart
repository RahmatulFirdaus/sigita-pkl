import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigita_online/drawerNav/drawerNavigasi.dart';
import 'package:sigita_online/navigasi/navigasiBar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navigasibar(),
      drawer: const Drawernavigasi(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromRGBO(202, 248, 253, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Welcome Header
            Text(
              "Selamat Datang di SIGITA",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 20),

            // Sections
            _buildInfoCard(
              icon: Icons.search,
              title: 'Mengapa Memilih SIGITA',
              description:
                  "SIGITA menawarkan berbagai modul pembelajaran yang mencakup semua aspek keperawatan. Modul dirancang interaktif, mudah dipahami, dengan simulasi kasus nyata untuk membantu Anda menguasai materi dengan lebih baik.",
            ),

            _buildInfoCard(
              icon: Icons.book,
              title: 'Modul Pembelajaran Unggulan',
              description:
                  "Dasar-dasar Keperawatan: Anatomi, terminologi medis, teknik dasar\nKeperawatan Klinis: Teknik perawatan, manajemen pasien\nKeperawatan Spesialis: Modul khusus anak, geriatri, komunitas",
            ),

            _buildInfoCard(
              icon: Icons.support_agent,
              title: 'Dukungan Ahli',
              description:
                  "Dapatkan bimbingan dari ahli dan praktisi keperawatan berpengalaman. Tim SIGITA siap membantu menjawab pertanyaan dan memberikan tips praktis untuk meningkatkan kompetensi Anda.",
            ),

            const SizedBox(height: 20),

            // Additional Information Section
            Text(
              "Lihat Informasi Lebih Lanjut",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 15),

            // YouTube Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse(
                      "https://www.youtube.com/@rsjsambanglihum4612"));
                },
                icon:
                    const Icon(Icons.play_circle_outline, color: Colors.white),
                label: Text(
                  "Cek Youtube Kami",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[50],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              description,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
