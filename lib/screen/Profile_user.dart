import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String username = "";
  String email = "";
  String profileImageUrl = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorText;
  bool _isSaveButtonEnabled = true; // Status tombol "Simpan"

  void _validatePasswords() {
    setState(() {
      // Jika kolom kata sandi baru dan konfirmasi kata sandi kosong
    if (_newPasswordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {
      _errorText = null; // Menghapus pesan error
      _isSaveButtonEnabled = true; // Mengaktifkan tombol "Simpan"
    }
    // Jika kata sandi baru diisi dan konfirmasi kata sandi kosong
    else if (_newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isEmpty) {
      _errorText = "Konfirmasi kata sandi harus diisi";
      _isSaveButtonEnabled = false; // Menonaktifkan tombol "Simpan"
    }
    // Jika kata sandi baru dan konfirmasi kata sandi tidak cocok
    else if (_newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text != _confirmPasswordController.text) {
      _errorText = "Password tidak cocok";
      _isSaveButtonEnabled = false; // Menonaktifkan tombol "Simpan"
    }
    // Jika password kosong atau cocok
    else {
      _errorText = null; // Menghapus pesan error
      _isSaveButtonEnabled = true; // Mengaktifkan tombol "Simpan"
    }
  });
}

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Pastikan validasi dilakukan sebelum menyimpan data
    _validatePasswords(); // Panggil validasi password sebelum menyimpan
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "User";
      username = prefs.getString('username') ?? "user123";
      email = prefs.getString('email') ?? "user@example.com";
      profileImageUrl =
          prefs.getString('profileImage') ?? "https://via.placeholder.com/150";
      _nameController.text = name;
      _usernameController.text = username;
      _emailController.text = email;
    });
  }

  Future<void> _saveUserData() async {
    if (_isSaveButtonEnabled) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Simpan data profil
      await prefs.setString('name', _nameController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('email', _emailController.text);

      // Simpan kata sandi baru jika diisi dan valid
      if (_newPasswordController.text.isNotEmpty) {
        await prefs.setString('password', _newPasswordController.text);
      }

      setState(() {
        name = _nameController.text;
        username = _usernameController.text;
        email = _emailController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil sukses diperbarui!")),
      );
    } else {
      // Jika password tidak cocok atau konfirmasi kata sandi kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Pastikan kata sandi dan konfirmasi kata sandi cocok!")),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
      setState(() {
        profileImageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: const Color(0xFF66BB6A),
        actions: [
          // Tombol logout sebagai ikon di AppBar
          Padding(
            padding:
                const EdgeInsets.only(right: 16.0), // Jarak ke sisi kanan layar
            child: IconButton(
              icon: const Icon(Icons.logout), // Ikon logout
              onPressed: () async {
                // Fungsi logout
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              tooltip: "Keluar", // Tooltip muncul saat ikon ditahan
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickProfileImage,
                          child: CircleAvatar(
                            backgroundImage: profileImageUrl.startsWith('http')
                                ? NetworkImage(profileImageUrl)
                                : FileImage(File(profileImageUrl))
                                    as ImageProvider,
                            radius: 50,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: (_) => _validatePasswords(), // Memanggil validasi password
                    decoration: InputDecoration(
                      labelText: "Kata Sandi Baru",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (_) => _validatePasswords(),
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Kata Sandi Baru",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      errorText: _errorText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isSaveButtonEnabled ? _saveUserData : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            foregroundColor: Colors.black,
                          ), // Disable tombol jika tidak valid
                          child: Text(
                            "Simpan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
