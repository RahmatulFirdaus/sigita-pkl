import 'package:flutter/material.dart';
import 'package:sigita_online/drawerNav/drawerNavigasi.dart';
import 'package:sigita_online/navigasi/navigasiBar.dart';
import 'package:google_fonts/google_fonts.dart';

class Faqpage extends StatelessWidget {
  const Faqpage({super.key});

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
          padding: EdgeInsets.zero,
          children: [
            Image.asset(
              "images/think.png",
              fit: BoxFit.cover,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Text(
                "Pertanyaan yang Sering Diajukan",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildFAQCard(
              context,
              icon: Icons.payment,
              title: 'Apakah ada biaya untuk mengikuti modul di SIGITA?',
              description:
                  "Beberapa modul di SIGITA gratis, namun ada juga modul premium yang memerlukan biaya. Informasi lebih lanjut mengenai biaya dapat dilihat pada halaman modul di situs web kami.",
            ),
            _buildFAQCard(
              context,
              icon: Icons.support_agent,
              title:
                  'Bagaimana cara mendapatkan bantuan jika mengalami kesulitan?',
              description:
                  "Jika Anda mengalami kesulitan atau memiliki pertanyaan, Anda bisa menghubungi tim dukungan kami melalui fitur kontak di situs web atau melalui nama.",
            ),
            _buildFAQCard(
              context,
              icon: Icons.update,
              title: 'Apakah materi di SIGITA selalu diperbarui?',
              description:
                  "Ya, kami secara rutin memperbarui materi pembelajaran kami untuk memastikan bahwa Anda mendapatkan informasi terbaru dan relevan di bidang keperawatan.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[50],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
