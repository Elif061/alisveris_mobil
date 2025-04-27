import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavorilerPage extends StatelessWidget {
  final List<DocumentSnapshot> favoriler;

  const FavorilerPage({Key? key, required this.favoriler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favori Ürünler',
          style: TextStyle(color: Colors.white), // 🌟 Yazı beyaz
        ),
        backgroundColor: const Color(0xff001F3F), // Koyu mavi arka plan
        iconTheme: const IconThemeData(color: Colors.white), // 🌟 Geri tuşu da beyaz
      ),
      body: favoriler.isEmpty
          ? const Center(
              child: Text(
                'Henüz favori ürün yok!',
                style: TextStyle(color: Colors.black), // Burayı istersen beyaz yapabiliriz
              ),
            )
          : ListView.builder(
              itemCount: favoriler.length,
              itemBuilder: (context, index) {
                var urun = favoriler[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      urun['resimUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(urun['ad']),
                    subtitle: Text('${urun['fiyat']} ₺'),
                  ),
                );
              },
            ),
    );
  }
}
