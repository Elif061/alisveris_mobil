import 'package:flutter/material.dart';
import 'urunler_listesi_page.dart';

class UrunKategoriSecPage extends StatelessWidget {
  final String kategori;

  const UrunKategoriSecPage({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Seçimi", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff001F3F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Migros Butonu
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                      kategori: kategori,
                      market: 'migros',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.store, color: Colors.white),
              label: const Text("Migros", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 20),
            // BİM Butonu
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                      kategori: kategori,
                      market: 'bim',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.store_mall_directory, color: Colors.white),
              label: const Text("BİM", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
