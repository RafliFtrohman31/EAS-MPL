import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // WAJIB IMPORT INI UNTUK METHOD CHANNEL
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;
  Timer? _debounceTimer;
  static const int _targetClicks = 8; 

  // 🔌 Inisialisasi Method Channel dengan nama identifier yang sama dengan Kotlin
  static const _platform = MethodChannel('uas.mobile.lanjut/npm_channel');
  String _nativeResult = "Belum dieksekusi";

  // Fungsi asynchronous untuk mengirim data ke Kotlin
  Future<void> _invokeNativeReverseNPM() async {
    try {
      // Mengirim data String NPM ke Kotlin dan menunggu respon balikan
      final String result = await _platform.invokeMethod('reverseNPM', {
        'npm': '20123048', 
      });
      
      setState(() {
        _nativeResult = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _nativeResult = "Gagal memanggil native: '${e.message}'.";
      });
    }
  }

  void _onProfileImageTapped() {
    if (_showEasterEgg) return;
    setState(() { _clickCount++; });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _clickCount < _targetClicks) {
        setState(() { _clickCount = 0; });
      }
    });

    if (_clickCount == _targetClicks) {
      _debounceTimer?.cancel();
      setState(() {
        _showEasterEgg = true;
        _clickCount = 0;
      });
      Timer(const Duration(seconds: 3), () {
        if (mounted) { setState(() { _showEasterEgg = false; }); }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengembang')),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _onProfileImageTapped,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 156,
                          height: 156,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 4),
                          ),
                        ),
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(Icons.person_rounded, size: 70, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Rafli Faturohman', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text('NPM: 20123048', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.secondary, letterSpacing: 1.1)),
                  const SizedBox(height: 4),
                  Text('S1 Informatika - Universitas Teknologi Digital', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                  
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // 🛠️ INTEGRASI UI UNTUK METHOD CHANNEL
                  ElevatedButton.icon(
                    onPressed: _invokeNativeReverseNPM,
                    icon: const Icon(Icons.android_rounded),
                    label: const Text('Panggil Method Channel Kotlin'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hasil Balikan Dart: $_nativeResult',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          if (_showEasterEgg)
            Container(
              color: Colors.black.withValues(alpha: 0.8),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_u4yrau.json',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Text(
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