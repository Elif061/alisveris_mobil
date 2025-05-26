import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart'; // ✅ global favori liste
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
  List<DocumentSnapshot> urunler = [];

  // ✅ 1. Özel ürün-resim eşleştirme haritası
  final Map<String, String> urunResimMap = {
    "Migros %3 Yağlı Süt": "migros_yuzde3_yagli_sut.png",
    "Güres M - Orta Boy Yumurta 30'lu": "gures_m_orta_boy_yumurta_30lu.png",
    "Coca-Cola Orijinal Tat": "coca_cola_orijinal_tat.png",
    "Tamek %100 Karışık Meyve Suyu": "tamek_yuzde100_karisik_meyve_suyu.png",
    "Omo Sıvı Active Cold Power Beyazlar ve Renkli...": "omo_sivi_active_cold_power_beyazlar_renkliler_camasir_deterjani.png",
    "Omo Sıvı Active Cold Power Beyazlar ve Renkliler İçin Çamaşır Deterjanı":
        "omo_sivi_active_cold_power_beyazlar_renkliler_camasir_deterjani.png",
    "Head & Shoulders Ekstra Hacim Kepek Karşıtı Şampuan": "head_shoulders_ekstra_hacim_kepek_karsiti_sampuan.png",
  };

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
      urunler = snapshot.docs;
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
      ),
      body: urunler.isEmpty
          ? const Center(child: Text("Ürün bulunamadı."))
          : ListView.builder(
              itemCount: urunler.length,
              itemBuilder: (context, index) {
                var urun = urunler[index];
                final ad = urun['ad'];
                final fiyat = urun['fiyat'];
                final eskiFiyat = urun.data().toString().contains('eskiFiyat')
                    ? double.tryParse(urun['eskiFiyat'].toString())
                    : null;
                final indirimdeMi = urun.data().toString().contains('indirimdeMi')
                    ? urun['indirimdeMi'] == true
                    : false;
                final market = urun['market'];

                final bool favorideMi = favoriUrunler.contains(urun);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: _buildUrunResmi(urun),
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
                          market == 'Migros' ? 'assets/migros.png' : 'assets/a101.png',
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("“$ad” favorilerden çıkarıldı."),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            favoriUrunler.add(urun);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("“$ad” favorilere eklendi."),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ✅ 2. Görsel alma fonksiyonu: önce özel eşleşmeye bakar, sonra otomatik dönüştürür
  Widget _buildUrunResmi(DocumentSnapshot urun) {
    final ad = urun['ad'].toString().trim();
    final resimUrl = urun['resimUrl'];

    String? assetName = urunResimMap[ad];

    if (assetName == null) {
      assetName = ad
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('ç', 'c')
          .replaceAll('ğ', 'g')
          .replaceAll('ı', 'i')
          .replaceAll('ö', 'o')
          .replaceAll('ş', 's')
          .replaceAll('ü', 'u')
          .replaceAll(RegExp(r'[^\w\s]'), '');
      assetName = '$assetName.png';
    }

    final assetPath = 'assets/$assetName';

    if (resimUrl != null && resimUrl.toString().isNotEmpty) {
      return Image.network(
        resimUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(assetPath, width: 50, height: 50, fit: BoxFit.cover),
      );
    } else {
      return Image.asset(
        assetPath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      );
    }
  }
}
