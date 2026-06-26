package com.example.uas_mobile_lanjut // Sesuaikan dengan nama package asli Anda

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Tentukan nama channel unik yang sama dengan sisi Dart
    private val CHANNEL = "uas.mobile.lanjut/npm_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Memeriksa jika method yang dipanggil bernama "reverseNPM"
            if (call.method == "reverseNPM") {
                val npmString = call.argument<String>("npm")
                
                if (npmString != null) {
                    // 🌟 TANTANGAN ANTI-AI: Membalikkan urutan String NPM di dalam Kotlin
                    val reversedNpm = npmString.reversed()
                    
                    // Menampilkan hasil pembalikan lewat Native Toast Android
                    Toast.makeText(this, "Kotlin Native Toast: $reversedNpm", Toast.LENGTH_LONG).show()
                    
                    // Mengembalikan nilai sukses ke sisi Dart
                    result.success(reversedNpm)
                } else {
                    result.error("INVALID_ARGUMENT", "NPM bernilai null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}