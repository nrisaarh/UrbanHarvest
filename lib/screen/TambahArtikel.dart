import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TambahArtikelScreen extends StatefulWidget {
  const TambahArtikelScreen({super.key});

  @override
  State<TambahArtikelScreen> createState() => _TambahArtikelScreenState();
}

class _TambahArtikelScreenState extends State<TambahArtikelScreen> {
  // Status pilihan untuk kedua ChoiceChip
  bool selectedHidroponik = false;
  bool selectedJamurTiram = false;
  File? _image; // Menyimpan file gambar yang dipilih
  bool isSectionTwoVisible = false; // Mengontrol visibilitas bagian kedua
  File? _headerImage; // Menyimpan gambar header artikel
  final ImagePicker _picker = ImagePicker();
  List<File> _supportingImages = []; // Menyimpan daftar foto pendukung
  List<String> _articleParagraphs = []; // Daftar paragraf artikel

// Controller untuk input teks
  final TextEditingController _namaPenulisController = TextEditingController();
  final TextEditingController _namaInstitusiController =
      TextEditingController();
  final TextEditingController _biodataPenulisController =
      TextEditingController();
  final TextEditingController _articleTitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImage(
      {bool isHeader = false, bool isSupporting = false}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isHeader) {
          _headerImage = File(pickedFile.path); // Gambar header
        } else if (isSupporting) {
          _supportingImages
              .add(File(pickedFile.path)); // Tambahkan ke daftar foto pendukung
        } else {
          _image = File(pickedFile.path); // foto profil
        }
      });
    }
  }

  // Fungsi untuk memeriksa apakah hanya satu ChoiceChip yang dapat dipilih
  void _onChoiceChipSelected(bool isHidroponik) {
    setState(() {
      if (isHidroponik) {
        selectedHidroponik = !selectedHidroponik;
        if (selectedHidroponik) {
          selectedJamurTiram = false; // Membatalkan pemilihan jamur tiram
        }
      } else {
        selectedJamurTiram = !selectedJamurTiram;
        if (selectedJamurTiram) {
          selectedHidroponik = false; // Membatalkan pemilihan hidroponik
        }
      }
    });
  }

  // Fungsi untuk membangun konten artikel
  List<Widget> _buildArticleContent() {
    List<Widget> content = [];
    for (int i = 0; i < _articleParagraphs.length; i++) {
      content.add(Text(
        _articleParagraphs[i],
        style: const TextStyle(fontSize: 16),
      ));
      if (i < _supportingImages.length) {
        content.add(SizedBox(height: 10));
        content.add(Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(_supportingImages[i]),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
      }
    }
    return content;
  }

  // Fungsi untuk memeriksa apakah semua input bagian 1 sudah diisi
  void _checkIfSectionOneCompleted() {
    if (_namaPenulisController.text.isNotEmpty &&
        _namaInstitusiController.text.isNotEmpty &&
        _biodataPenulisController.text.isNotEmpty) {
      setState(() {
        isSectionTwoVisible = true; // Menampilkan bagian kedua
      });
    }
  }

  bool _isFormComplete() {
    return _articleTitleController.text.isNotEmpty && // Validasi Judul
        _headerImage != null && // Validasi Gambar Header
        _contentController.text.isNotEmpty && // Validasi Konten
        _supportingImages.isNotEmpty; // Validasi Gambar Pendukung
  }

  @override
  void dispose() {
    _articleTitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveArticle() {
    // Logika untuk menyimpan artikel, bisa berupa API call atau menyimpan data ke database
    // Misalnya, tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Artikel Disimpan'),
        content: const Text('Artikel Anda telah berhasil disimpan.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
              Navigator.pop(context); // Menutup halaman TambahArtikel
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFAE7), // Warna latar belakang
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFFAE7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambah Artikel',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Bagian 1',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const LinearProgressIndicator(
              value: 0.5, // Menampilkan progress separuh
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 27, 110, 23)),
            ),
            const SizedBox(height: 20),
            // Foto profil bulat
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () =>
                        _pickImage(), // Panggil _pickImage saat area foto ditekan
                    child: CircleAvatar(
                      radius: 50, // Ukuran bulat
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              size: 50,
                              color: Colors
                                  .white) // Ikon kamera jika gambar belum dipilih
                          : null,
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Jarak antara CircleAvatar dan teks
                  if (_image == null)
                    const Text(
                      'Klik untuk memasang foto profil penulis',
                      style: TextStyle(color: Colors.black54),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Jenis artikel yang ditulis:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ChoiceChip(
                    label: Text(
                      'Hidroponik',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedHidroponik ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: selectedHidroponik,
                    onSelected: (bool selected) {
                      _onChoiceChipSelected(true); // Pilih hidroponik
                    },
                    selectedColor: const Color(0xFF7DC579),
                    backgroundColor: Colors.transparent,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Jarak antara ChoiceChip
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ChoiceChip(
                    label: Text(
                      'Jamur Tiram',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedJamurTiram ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: selectedJamurTiram,
                    onSelected: (bool selected) {
                      _onChoiceChipSelected(false); // Pilih jamur tiram
                    },
                    selectedColor: const Color(0xFF7DC579),
                    backgroundColor: Colors.transparent,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            // Menampilkan konten lainnya hanya jika chip dipilih
            if (selectedHidroponik || selectedJamurTiram) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _namaPenulisController,
                decoration: InputDecoration(
                  labelText: 'Nama Penulis',
                  hintText: 'Masukkan nama penulis',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onChanged: (_) => _checkIfSectionOneCompleted(),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _namaInstitusiController,
                decoration: InputDecoration(
                  labelText: 'Nama Institusi',
                  hintText: 'Masukkan nama institusi',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onChanged: (_) => _checkIfSectionOneCompleted(),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _biodataPenulisController,
                decoration: InputDecoration(
                  labelText: 'Biodata Penulis',
                  hintText: 'Contoh: just a newbie writer',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onChanged: (_) => _checkIfSectionOneCompleted(),
              ),
            ],

            if (isSectionTwoVisible) ...[
              const SizedBox(height: 20),
              const Text(
                'Bagian 2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 27, 110, 23)),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(isHeader: true),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _headerImage != null
                        ? DecorationImage(
                            image: FileImage(_headerImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _headerImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 50,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Klik untuk unggah foto header',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _articleTitleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Artikel',
                  hintText: 'contoh: hidroponik',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Konten Artikel',
                  hintText: 'Masukkan isi artikel',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Foto Pendukung Artikel:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(
                        isSupporting:
                            true), // Memanggil fungsi untuk foto pendukung
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Tambah Foto Pendukung'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Warna tombol
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildArticleContent(), // Menampilkan daftar foto pendukung
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _supportingImages.map((image) {
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _supportingImages.remove(
                                      image); // Hapus gambar dari daftar
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  // Tombol Simpan Artikel (diletakkan di tengah)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormComplete()) {
                          // Semua data valid, simpan artikel
                          _saveArticle();
                        } else {
                          // Tampilkan pesan peringatan jika data belum lengkap
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Harap lengkapi semua data sebelum menyimpan artikel.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Simpan Artikel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
