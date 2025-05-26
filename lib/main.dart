import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Favori ürünler için eklendi

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart'; // ✅ Ana sayfa burada

// ✅ Global favori ürün listesi:
List<DocumentSnapshot> favoriUrunler = [];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aldım Gitti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 🔐 Oturum kontrolü:
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const HomePage(); // ✅ Giriş yapan kullanıcı => Ana Sayfa
          } else {
            return const LoginPage(); // 🔐 Oturum yok => Login
          }
        },
      ),
    );
  }
}
