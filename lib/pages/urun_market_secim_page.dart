import 'package:flutter/material.dart';
import 'urunler_listesi_page.dart';

class UrunMarketSecimPage extends StatelessWidget {
  final String kategoriAdi; // Örneğin: "meyve-sebze", "sut-kahvaltilik"

  const UrunMarketSecimPage({Key? key, required this.kategoriAdi}) : super(key: key);

  // "meyve-sebze" → "Meyve Sebze"
  String duzenlenmisKategoriAdi(String text) {
    return text.split('-').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    String gosterimAdi = duzenlenmisKategoriAdi(kategoriAdi);

    return Scaffold(
      appBar: AppBar(
        title: Text('$gosterimAdi - Market Seçimi'),
        backgroundColor: const Color(0xff001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Migros Butonu
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                     kategori: kategoriAdi.toLowerCase(), // yani sadece 'meyve-sebze' gibi
market: 'Migros', // Firestore'daki gibi büyük harfli

                    ),
                  ),
                );
              },
              icon: const Icon(Icons.store, color: Colors.white),
              label: const Text('Migros Ürünleri', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // A101 Butonu
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                      kategori: '${kategoriAdi.toLowerCase()}-a101',
                      market: 'a101',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.store, color: Colors.white),
              label: const Text('A101 Ürünleri', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
