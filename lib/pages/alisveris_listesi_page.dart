import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlisverisListesiPage extends StatefulWidget {
  const AlisverisListesiPage({super.key});

  @override
  State<AlisverisListesiPage> createState() => _AlisverisListesiPageState();
}

class _AlisverisListesiPageState extends State<AlisverisListesiPage> {
  final TextEditingController _urunController = TextEditingController();

  void _urunEkle() async {
    if (_urunController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('alisverisListesi').add({
      'isim': _urunController.text,
      'eklenmeTarihi': Timestamp.now(),
    });

    _urunController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alışveriş Listesi")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urunController,
                    decoration: const InputDecoration(labelText: "Ürün adı"),
                  ),
                ),
                IconButton(
                  onPressed: _urunEkle,
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('alisverisListesi')
                  .orderBy('eklenmeTarihi', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final veri = docs[index];
                    return ListTile(
                      title: Text(veri['isim']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          veri.reference.delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
