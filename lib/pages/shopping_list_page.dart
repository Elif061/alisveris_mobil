import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addItemToFirestore(String item) async {
    if (item.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('alisveris_listesi').add({
      'urun': item.trim(),
      'done': false,
      'eklenme_tarihi': Timestamp.now(),
    });

    _controller.clear();
  }

  Future<void> _toggleDone(DocumentSnapshot doc) async {
    final current = doc['done'] as bool;
    await doc.reference.update({'done': !current});
  }

  Future<void> _removeItem(DocumentSnapshot doc) async {
    await doc.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Alışveriş Listesi",
          style: TextStyle(color: Colors.white), // 🌟 Yazı beyaz
        ),
        backgroundColor: const Color(0xff001F3F),
        iconTheme: const IconThemeData(color: Colors.white), // 🌟 Geri ikonu beyaz
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Ürün adı",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addItemToFirestore(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff001F3F),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    "Ekle",
                    style: TextStyle(color: Colors.white), // 🌟 Ekle yazısı da beyaz
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('alisveris_listesi')
                    .orderBy('eklenme_tarihi', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () => _toggleDone(doc),
                        onLongPress: () => _removeItem(doc),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: Text(
                              data['urun'] ?? '',
                              style: TextStyle(
                                decoration: (data['done'] == true)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: Icon(
                              data['done'] == true
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: data['done'] == true ? Colors.green : null,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
