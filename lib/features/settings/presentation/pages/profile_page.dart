import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variabel untuk melacak jumlah ketukan (Tantangan Anti-AI)
  int _clickCount = 0;
  bool _showEasterEgg = false;
  Timer? _debounceTimer;

  // Target klik berdasarkan digit terakhir NPM Rafli (20123048 -> 8)
  static const int _targetClicks = 8; 

  void _onProfileImageTapped() {
    // Jika animasi sedang berjalan, abaikan klik baru
    if (_showEasterEgg) return;

    setState(() {
      _clickCount++;
    });

    // Reset hitungan jika user terlalu lama menjeda ketukan (lebih dari 1.5 detik)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _clickCount < _targetClicks) {
        setState(() {
          _clickCount = 0;
        });
      }
    });

    // Jika ketukan tepat mencapai target 8 kali
    if (_clickCount == _targetClicks) {
      _debounceTimer?.cancel();
      setState(() {
        _showEasterEgg = true;
        _clickCount = 0; // Reset hitungan
      });

      // Sembunyikan kembali animasi Lottie setelah 3 detik sesuai regulasi EAS
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showEasterEgg = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: Stack(
        children: [
          // 1. TAMPILAN UTAMA PROFIL (Style Elegan Modern)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Deteksi Ketukan menggunakan GestureDetector / InkWell pada Foto Profil
                  GestureDetector(
                    onTap: _onProfileImageTapped,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ring Dekoratif Elegan
                        Container(
                          width: 156,
                          height: 156,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              width: 4,
                            ),
                          ),
                        ),
                        // Foto Profil Utama
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 70,
                            color: Colors.white,
                          ), // Silakan ganti dengan AssetImage/NetworkImage foto Anda
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Detail Informasi Mahasiswa Sesuai Berkas Berkas Kelulusan
                  Text(
                    'Rafli Faturohman',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NPM: 20123048',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S1 Informatika - Universitas Teknologi Digital',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  // Petunjuk interaktif halus untuk demo video Anda
                  Text(
                    'Petunjuk Video Demo: Ketuk foto profil 8x secara cepat untuk memicu Easter Egg.',
                    style: theme.textTheme.labelSmall?.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 2. LAYER EASTER EGG (Memenuhi Layar Selama 3 Detik)
          if (_showEasterEgg)
            Container(
              color: Colors.black.withValues(alpha: 0.8), // Menggelapkan background utama
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_u4yrau.json', // URL Animasi Perayaan/Sukses
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text(
                    '🎉 EASTER EGG AKTIF (8 KLIKS) 🎉',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}