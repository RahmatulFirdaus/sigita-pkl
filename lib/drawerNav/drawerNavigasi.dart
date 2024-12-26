import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigita_online/pages/login/login_page.dart';
import 'package:sigita_online/pages/profile.dart';
import 'package:sigita_online/pages/dashboard.dart';
import 'package:sigita_online/models/sigitaModel.dart';
import 'package:sigita_online/pages/faqPage.dart';

import 'package:sigita_online/pages/topik/topik_page.dart';


class Drawernavigasi extends StatefulWidget {
  const Drawernavigasi({super.key});

  @override
  State<Drawernavigasi> createState() => _DrawernavigasiState();
}

class _DrawernavigasiState extends State<Drawernavigasi> {
  List<GetKategori> dataKategori = [];

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    GetKategori.getKategori().then((nilai) {
      setState(() {
        dataKategori = nilai;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/rsnew.png"), fit: BoxFit.cover),
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined, color: Colors.black),
            title: const Text(
              "Dashboard",
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const DashboardPage();
                },
              ));
            },
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: const Icon(
                Icons.topic_outlined,
                color: Colors.black,
              ),
              title: const Text("Topik", style: TextStyle(fontSize: 14)),
              children: dataKategori.map((kategori) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: const Icon(
                      Icons.article_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      kategori.kategori,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    onTap: () {
                      _selectedIndex = dataKategori.indexOf(kategori);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Topikpage(id: dataKategori[_selectedIndex].id),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.help_outline_outlined, color: Colors.black),
            title: Text(
              "FAQ",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Faqpage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined,
                color: Colors.black),
            title: Text(
              "Profile",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Profilepage()));
            },
          ),
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.logout_outlined,
                  color: Colors.black),
              title: Text(
                "Logout",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

