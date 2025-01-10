  import 'package:flutter/material.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:sigita_online/models/adminModel.dart';
  import 'package:toastification/toastification.dart';

  class TambahAkun extends StatefulWidget {
    const TambahAkun({super.key});

    @override
    _TambahAkunState createState() => _TambahAkunState();
  }

  class _TambahAkunState extends State<TambahAkun> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _kode_perawatController = TextEditingController();

    String _selectedRole = "Perawat";
    bool _isPasswordVisible = false;

    void _submitData() async {
      String username = _usernameController.text;
      String password = _passwordController.text;
      String phone = _phoneController.text;
      String name = _nameController.text;
      String kode_perawat = _kode_perawatController.text;

      if (username.isEmpty ||
          password.isEmpty ||
          phone.isEmpty ||
          name.isEmpty ||
          kode_perawat.isEmpty) {
        toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan"),
          description: const Text("Harap isi semua data"),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.error_outline),
        );
        return;
      }
      try {
        await PostAccount.postAccount(
            username, password, _selectedRole, phone, name, kode_perawat);
      toastification.show(
          context: context,
          title: const Text("Berhasil"),
          description: const Text("Akun telah berhasil ditambahkan"),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.check_circle_outlined),
        );
        Navigator.pop(context);
      } catch (e) {
        toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan"),
          description: Text("Gagal menambahkan akun : $e"),
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.error_outline),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            "Tambah Akun",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _usernameController,
                    labelText: "Username",
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    labelText: "Phone",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    labelText: "Name",
                    prefixIcon: Icons.person_pin_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _kode_perawatController,
                    labelText: "kode_perawat",
                    prefixIcon: Icons.account_balance_outlined,
                  ),
                  const SizedBox(height: 20),
                  const Text("Role",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
                  _buildRoleSelection(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildTextField({
      required TextEditingController controller,
      required String labelText,
      required IconData prefixIcon,
      bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon,
    }) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
            ),
          ),
        ),
      );
    }

    Widget _buildRoleSelection() {
      return Row(
        children: [
          Expanded(
            child: _buildRoleChip(
              label: "Perawat",
              isSelected: _selectedRole == "perawat",
              onSelected: () => setState(() => _selectedRole = "perawat"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildRoleChip(
              label: "Admin",
              isSelected: _selectedRole == "admin",
              onSelected: () => setState(() => _selectedRole = "admin"),
            ),
          ),
        ],
      );
    }

    Widget _buildRoleChip({
      required String label,
      required bool isSelected,
      required VoidCallback onSelected,
    }) {
      return GestureDetector(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildSubmitButton() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text("Tambah Akun",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      );
    }
  }
