import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigita_online/adminpage/adminAccountPage.dart';
import 'package:sigita_online/adminpage/adminKategoriPage.dart';
import 'package:sigita_online/adminpage/adminMainPage.dart';
import 'package:sigita_online/adminpage/adminPostinganPage.dart';

class Getxcontrollerpage extends StatefulWidget {
  const Getxcontrollerpage({super.key});

  @override
  State<Getxcontrollerpage> createState() => _GetxcontrollerpageState();
}

class _GetxcontrollerpageState extends State<Getxcontrollerpage> {
  final NavigationController _navController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _navController.screen[_navController.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            currentIndex: _navController.selectedIndex.value,
            onTap: (index) {
              _navController.updateIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.poll_sharp),
                label: "Postingan",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.polyline),
                label: "Kategori",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account_rounded),
                label: "Account",
              ),
            ],
          ),
        ));
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screen = [
    const Adminmainpage(),
    const Adminpostinganpage(),
    const Adminkategoripage(),
    const AdminAccountPage()
  ];

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
