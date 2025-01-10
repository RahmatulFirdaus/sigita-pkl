import 'package:flutter/material.dart';
import 'package:sigita_online/adminpage/getXController.dart';
import 'package:sigita_online/models/sigitaModel.dart';
import 'package:sigita_online/pages/dashboard.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // physics: const NeverScrollabljaeScrollPhysics(),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo or app name could go here
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Enhanced text fields
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: usernameController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: const TextStyle(fontSize: 14),
                              prefixIcon:
                                  const Icon(Icons.person_outlined, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(fontSize: 14),
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Enhanced button
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (usernameController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                try {
                                  String? result = await LoginSigita.login(
                                    usernameController.text,
                                    passwordController.text,
                                  );

                                  if (result == "admin") {
                                    toastification.show(
                                      context: context,
                                      title: const Text("Login Berhasil"),
                                      description: const Text(
                                          "Selamat Datang Di SIGITA"),
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      icon: const Icon(Icons.check),
                                    );
                                    await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Getxcontrollerpage()),
                                    );
                                  } else if (result == "perawat") {
                                    toastification.show(
                                      context: context,
                                      title: const Text("Login Berhasil"),
                                      description: const Text(
                                          "Selamat Datang Di SIGITA"),
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      icon: const Icon(Icons.check),
                                    );
                                    await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardPage()),
                                    );
                                  } else {
                                    toastification.show(
                                      context: context,
                                      title: const Text("Login Gagal"),
                                      description: Text(
                                          result!),
                                      type: ToastificationType.error,
                                      style: ToastificationStyle.flat,
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      icon: const Icon(Icons.error_outline),
                                    );
                                  }
                                } catch (e) {
                                  toastification.show(
                                    context: context,
                                    title: const Text("Login Gagal"),
                                    description: Text("Terjadi kesalahan: $e"),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.flat,
                                    alignment: Alignment.topCenter,
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    icon: const Icon(Icons.error_outline),
                                  );
                                }
                              } else {
                                toastification.show(
                                  context: context,
                                  title: const Text("Login Gagal"),
                                  description: const Text(
                                      "Username dan Password tidak boleh kosong"),
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.flat,
                                  alignment: Alignment.topCenter,
                                  autoCloseDuration: const Duration(seconds: 5),
                                  icon: const Icon(Icons.error_outline),
                                );
                              }
                            },
                            child: const Text("Login"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
