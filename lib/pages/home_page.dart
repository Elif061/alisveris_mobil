import 'package:flutter/material.dart';
import 'shopping_list_page.dart';
import 'urunler_listesi_page.dart';
import 'favoriler_page.dart'; // 🌟 Favoriler sayfasını ekliyoruz

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff001F3F),
        title: Row(
          children: [
            Image.asset(
              'assets/projelogosu.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text("Aldım Gitti", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // ✅ Meyve-Sebze Ürünleri Butonu
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UrunlerListesiPage(kategori: 'meyve-sebze'),
                  ),
                );
              },
              icon: const Icon(Icons.local_grocery_store, color: Colors.white),
              label: const Text(
                "Meyve-Sebze Ürünleri",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff001F3F),
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // 🛒 Favoriler Butonu
          Positioned(
            bottom: 90,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Şimdilik boş favoriler listesi gönderiyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavorilerPage(favoriler: []),
                  ),
                );
              },
              label: const Text(
                'Favoriler',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.favorite, color: Colors.white),
              backgroundColor: const Color(0xffe53935), // Kırmızı favori rengi
            ),
          ),

          // 🛍️ Alışveriş Listesi Butonu
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingListPage()),
                );
              },
              label: const Text(
                'Alışveriş Listesi',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              backgroundColor: const Color(0xff001F3F),
            ),
          ),
        ],
      ),
    );
  }
}
