import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favoriler_page.dart'; // 🌟 Favoriler sayfasını import ediyoruz

class UrunlerListesiPage extends StatefulWidget {
  final String kategori;

  const UrunlerListesiPage({Key? key, required this.kategori}) : super(key: key);

  @override
  State<UrunlerListesiPage> createState() => _UrunlerListesiPageState();
}

class _UrunlerListesiPageState extends State<UrunlerListesiPage> {
  List<DocumentSnapshot> favoriler = []; // 🌟 Favorilere eklenen ürünler burada tutulacak

  @override
  Widget build(BuildContext context) {
    CollectionReference urunler = FirebaseFirestore.instance.collection('urunler');

    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Meyve ve Sebzeler',
    style: TextStyle(color: Colors.white), // 🌟 Yazı beyaz
  ),
  backgroundColor: const Color(0xff001F3F),
  iconTheme: const IconThemeData(color: Colors.white), // 🌟 Geri butonunu da beyaz yapar
  actions: [
    IconButton(
      icon: const Icon(Icons.favorite_border, color: Colors.white), // 🌟 Sağ üst favori ikonu da beyaz
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavorilerPage(favoriler: favoriler),
          ),
        );
      },
    ),
  ],
),

      body: FutureBuilder<QuerySnapshot>(
        future: urunler.where('kategori', isEqualTo: widget.kategori).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu.'));
          }

          final urunlerList = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: urunlerList.length,
            itemBuilder: (context, index) {
              var urun = urunlerList[index];
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
                  trailing: IconButton(
                    icon: Icon(
                      favoriler.contains(urun)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriler.contains(urun)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favoriler.contains(urun)) {
                          favoriler.remove(urun);
                        } else {
                          favoriler.add(urun);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
