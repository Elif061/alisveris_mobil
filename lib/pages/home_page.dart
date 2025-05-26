import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shopping_list_page.dart';
import 'urun_kategori_sec_page.dart';
import 'favoriler_page.dart';
import 'chat_page.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _aramaController = TextEditingController();
  List<QueryDocumentSnapshot> aramaSonuclari = [];

  String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');
  }

  Future<void> _urunAra() async {
    final kelime = _aramaController.text.trim();
    if (kelime.isEmpty) return;

    final snapshot =
        await FirebaseFirestore.instance.collection('urunler').get();

    final filtrelenmis = snapshot.docs.where((doc) {
      final ad = doc['ad'].toString();
      return normalize(ad).contains(normalize(kelime));
    }).toList();

    setState(() {
      aramaSonuclari = filtrelenmis;
    });

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        if (aramaSonuclari.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Üzgünüz, aradığınız ürün bulunamadı.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: aramaSonuclari.length,
          itemBuilder: (context, index) {
            final urun = aramaSonuclari[index];
            final ad = urun['ad'];
            final fiyat = urun['fiyat'];
            final eskiFiyat = urun.data().toString().contains('eskiFiyat')
                ? double.tryParse(urun['eskiFiyat'].toString())
                : null;
            final indirimdeMi =
                urun.data().toString().contains('indirimdeMi') &&
                    urun['indirimdeMi'] == true;
            final market = urun['market'];
            final resimUrl = urun['resimUrl'];
            final favorideMi = favoriUrunler.contains(urun);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Image.network(
                  resimUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                title: Text(ad),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₺${fiyat.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (indirimdeMi && eskiFiyat != null && eskiFiyat > fiyat)
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    if (indirimdeMi && eskiFiyat != null && eskiFiyat > fiyat)
                      Text(
                        '₺${eskiFiyat.toString()}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Image.asset(
                      market == 'Migros'
                          ? 'assets/migros.png'
                          : 'assets/a101.png',
                      width: 40,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    favorideMi ? Icons.favorite : Icons.favorite_border,
                    color: favorideMi ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (favorideMi) {
                        favoriUrunler.remove(urun);
                      } else {
                        favoriUrunler.add(urun);
                      }
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff001F3F),
        title: Row(
          children: [
            Image.asset('assets/projelogosu.png', width: 40, height: 40),
            const SizedBox(width: 10),
            const Text("Aldım Gitti", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _aramaController,
                decoration: InputDecoration(
                  hintText: "Ne arıyorsunuz? Örneğin ‘süt’ ya da ‘çay’...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _urunAra,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff001F3F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Ara", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              buildKategoriButton("Meyve-Sebze Ürünleri", Icons.eco, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'meyve-sebze'),
                  ),
                );
              }),
              buildKategoriButton("Et-Tavuk-Balık", Icons.set_meal, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'et-tavuk-balik'),
                  ),
                );
              }),
              buildKategoriButton("Süt-Kahvaltılık", Icons.free_breakfast, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'sut-kahvaltilik'),
                  ),
                );
              }),
              buildKategoriButton("Temel Gıda", Icons.restaurant, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'temel-gida'),
                  ),
                );
              }),
              buildKategoriButton("İçecek", Icons.local_drink, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'icecek'),
                  ),
                );
              }),
              buildKategoriButton("Atıştırmalık", Icons.emoji_food_beverage, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'atistirmalik'),
                  ),
                );
              }),
              buildKategoriButton("Deterjan-Temizlik", Icons.cleaning_services, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'deterjan-temizlik'),
                  ),
                );
              }),
              buildKategoriButton("Kişisel Bakım", Icons.spa, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UrunKategoriSecPage(kategori: 'kisisel-bakim'),
                  ),
                );
              }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.3),
            builder: (context) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 250,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(top: 100, left: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xfff9f3fc),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.red),
                          title: const Text('Favoriler'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FavorilerPage(favoriler: favoriUrunler),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: const Text('Alışveriş Listesi'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShoppingListPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.smart_toy),
                          title: const Text('Akıllı Asistan'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.menu, color: Colors.white),
        backgroundColor: const Color(0xff001F3F),
      ),
    );
  }

  Widget buildKategoriButton(String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF001F3F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
