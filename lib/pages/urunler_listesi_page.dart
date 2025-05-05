import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favoriler_page.dart';

class UrunlerListesiPage extends StatefulWidget {
  final String kategori;
  final String market;

  const UrunlerListesiPage({
    Key? key,
    required this.kategori,
    required this.market,
  }) : super(key: key);

  @override
  State<UrunlerListesiPage> createState() => _UrunlerListesiPageState();
}

class _UrunlerListesiPageState extends State<UrunlerListesiPage> {
  List<DocumentSnapshot> favoriler = [];
  List<DocumentSnapshot> tumUrunler = [];
  List<DocumentSnapshot> filtreliUrunler = [];
  final TextEditingController aramaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('urunler')
        .where('kategori', isEqualTo: widget.kategori)
        .where('market', isEqualTo: widget.market)
        .get();

    setState(() {
      tumUrunler = snapshot.docs;
      filtreliUrunler = tumUrunler;
    });
  }

  void _ara(String kelime) {
    setState(() {
      filtreliUrunler = tumUrunler.where((urun) {
        final ad = urun['ad'].toString().toLowerCase();
        return ad.contains(kelime.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.market.toUpperCase()} - ${widget.kategori.replaceAll('-', ' ').toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff001F3F),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
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
      body: Column(
        children: [
          // 🔍 Arama Çubuğu
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: aramaController,
              decoration: const InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _ara,
            ),
          ),

          // 📦 Ürün Listesi
          Expanded(
            child: filtreliUrunler.isEmpty
                ? const Center(child: Text('Ürün bulunamadı.'))
                : ListView.builder(
                    itemCount: filtreliUrunler.length,
                    itemBuilder: (context, index) {
                      var urun = filtreliUrunler[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
