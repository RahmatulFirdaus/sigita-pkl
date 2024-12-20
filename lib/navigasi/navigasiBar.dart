import 'package:flutter/material.dart';

class Navigasibar extends StatelessWidget implements PreferredSizeWidget {
  const Navigasibar({super.key});

  // Define the preferred size for the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Make AppBar transparent to allow the gradient to show
      backgroundColor: Colors.transparent,
      // Remove the default shadow
      elevation: 0,
      // Center the title
      // centerTitle: true,
      // Title of the AppBar
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'images/logo.png',
            width: 30,
          ),
        ],
      ),
      // Add a gradient background using flexibleSpace
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(202, 248, 253, 1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
