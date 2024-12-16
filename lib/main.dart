import 'dart:async';
import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tubesfix/firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer untuk navigasi otomatis setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // Periksa apakah widget masih terpasang
        Navigator.of(context).pushReplacement(_createRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Ubah latar belakang menjadi putih
        ),
        child: Center(
          child: Image.asset(
            'assets/logo_Uh.png', // Logo UrbanHarvest
            width: 800,
            height: 400,
          ),
        ),
      ),
    );
  }
}

// Fungsi untuk membuat animasi transisi ke halaman sliding
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SlidingScreen(),
    fullscreenDialog: true, // Memastikan layar sepenuhnya digantikan
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Animasi fade (memudar)
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut));

      // Animasi scale (membesar perlahan)
      var scaleTween = Tween<double>(begin: 0.9, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut));

      // Kombinasi FadeTransition dan ScaleTransition
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: ScaleTransition(
          scale: animation.drive(scaleTween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 1500), // 1.5 detik
  );
}

class SlidingScreen extends StatefulWidget {
  const SlidingScreen({super.key});

  @override
  SlidingScreenState createState() => SlidingScreenState();
}

class SlidingScreenState extends State<SlidingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3; // Jumlah total slide
  Timer? _timer; // Timer untuk animasi otomatis

  @override
  void initState() {
    super.initState();
    // Memulai timer untuk animasi otomatis
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        timer.cancel(); // Hentikan animasi jika sudah sampai di slide terakhir
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer dihentikan saat widget dihancurkan
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildPage(
                "assets/image1.png",
                "Siapkah Anda untuk Hidroponik yang Lebih Mudah dan Cerdas? Mari Mulai!",
              ),
              _buildPage(
                "assets/image2.png",
                "Jadwalkan Panen Anda, Pantau Pertumbuhan, dan Jadilah Penggiat Hidroponik yang Hebat!",
              ),
              _buildPage(
                "assets/image3.png",
                "Edukasi, Pantauan, dan Solusi Hidroponik\nTemukan semua di UrbanHarvest!",
              ),
            ],
          ),
          // Tombol hanya muncul di slide terakhir
          if (_currentPage == _totalPages - 1)
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.green, // Warna tombol
                    shape: BoxShape.circle, // Bentuk lingkaran
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Bayangan
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward, // Ikon panah kanan
                    color: Colors.white, // Warna ikon putih
                    size: 24, // Ukuran ikon
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(String imagePath, String text) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
