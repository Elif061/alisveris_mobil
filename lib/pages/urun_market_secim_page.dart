import 'package:flutter/material.dart';
import 'urunler_listesi_page.dart'; // ürün liste ekranımızı import ediyoruz

class UrunMarketSecimPage extends StatelessWidget {
  final String kategoriAdi; // örneğin "meyve-sebze"

  const UrunMarketSecimPage({Key? key, required this.kategoriAdi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$kategoriAdi - Market Seçimi'),
        backgroundColor: const Color(0xff001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                      kategori: '${kategoriAdi.toLowerCase()}-migros',
                    ),
                  ),
                );
              },
              child: const Text('Migros Ürünleri'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UrunlerListesiPage(
                      kategori: '${kategoriAdi.toLowerCase()}-a101',
                    ),
                  ),
                );
              },
              child: const Text('A101 Ürünleri'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
