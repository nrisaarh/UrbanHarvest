import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'artikel.dart';
import 'Profile_user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "User";
  String email = "user@example.com";
  String username = "user123";
  String profileImageUrl = "";
  int _selectedIndex = 0; // Untuk mengelola indeks menu yang dipilih
  // bool _showHidroponik = true; // Menyimpan status switch

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "User";
      email = prefs.getString('email') ?? "user@example.com";
      username = prefs.getString('username') ?? "user123";
      profileImageUrl =
          prefs.getString('profileImage') ?? "https://via.placeholder.com/150";
    });
  }

  Future<void> _saveUserData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    _loadUserData(); // Update state setelah data disimpan
  }

  // Fungsi untuk mengubah tampilan berdasarkan menu yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Daftar tampilan untuk setiap menu
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Utama Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Perkiraan Panen Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Lapak Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFFAE7), // Background color

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()),
                          ).then((_) {
                            // Menyegarkan data setelah kembali dari ProfileScreen
                            _loadUserData();
                          });
                        },
                        child: CircleAvatar(
                          backgroundImage: profileImageUrl.isEmpty || profileImageUrl.startsWith('http')
                              ? NetworkImage(profileImageUrl)
                              : FileImage(File(profileImageUrl))
                                  as ImageProvider,
                          radius: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Halo, selamat sore! 👋",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Weather Section
              Text(
                "Cuaca Saat ini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFD5ECC2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sepinggan, Balikpapan Selatan",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "30°C",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            Icon(Icons.wb_sunny,
                                size: 40, color: Colors.orange),
                            Text("Cerah"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Suhu terlalu panas, atur ventilasi tanaman!",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Komoditas Section
              Text(
                "Artikel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildArtikelCard("Artikel Hidroponik",
                      "https://statics.indozone.news/local/645c9eec0361c.jpg"),
                  const SizedBox(width: 10),
                  _buildArtikelCard("Artikel Jamur Tiram",
                      "https://s3.bukalapak.com/bukalapak-kontenz-production/content_attachments/24088/original/01_Budidaya_Jamur_Tiram.jpg"),
                ],
              ),

              const SizedBox(height: 20),
              // Lapak Jual Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lapak Jual",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Tindakan ketika 'Selengkapnya' di-klik
                    },
                    child: Text(
                      "Selengkapnya",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 4, // Ganti dengan jumlah produk
                itemBuilder: (context, index) {
                  List<String> imageUrls = [
                    "https://1.bp.blogspot.com/-05xpvli-cFU/V_3vSym6IMI/AAAAAAAAAOw/j6tv_OT74q0SEIS3SaYEe0ibeJDdWDjeACLcB/s1600/Cara-Menanam-Selada-Secara-Hidroponik-Dengan-Alat-Sederhana.jpg",
                    "https://th.bing.com/th/id/R.d298f9a5d9241514ec148ccef0279a83?rik=tbq9EvCFgklQpw&riu=http%3a%2f%2f4.bp.blogspot.com%2f-mXCb4t4Pl44%2fTWXmfUfDFlI%2fAAAAAAAAAB8%2fRE1P9hapssU%2fw1200-h630-p-k-no-nu%2fJamur-Tiram-Putih.jpg&ehk=ye0iRwqWOKar%2fopIve7h%2bBOLqaDQMNqGPEokDsnlXxU%3d&risl=&pid=ImgRaw&r=0",
                    "https://thegorbalsla.com/wp-content/uploads/2020/02/Persemaian-Tanaman-Melon-Hidroponik.jpg",
                    "https://asset.kompas.com/crops/sqhglH26AgQ_1Ay729WVOFfqzhI=/100x0:945x563/750x500/data/photo/2020/07/02/5efccd6a31d12.jpg",
                  ];

                  // Daftar nama produk
                  List<String> productNames = [
                    "Tomat Hidroponik",
                    "Jamur Tiram",
                    "Melon Hidroponik",
                    "Kangkung Hidroponik",
                  ];

                  return _buildLapakCard(productNames[index],
                      imageUrls[index] // Menggunakan nama produk dari daftar
                      );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Perkiraan Panen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Lapak',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildArtikelCard(String title, String imageUrl) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtikelScreen(artikelTitle: title),
              ));
        },
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center, // Pastikan tetap di tengah
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLapakCard(String title, String imageUrl) {
    return Column(
      children: [
        Container(
          width: double.infinity, // Penuhi seluruh lebar kotak
          height: 180, // Sesuaikan dengan tinggi yang diinginkan
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit
                  .cover, // Memastikan gambar mengisi kotak tanpa distorsi
            ),
          ),
        ),
        const SizedBox(
            height: 8), // Memberi jarak antara gambar dan nama produk
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
