import 'package:flutter/material.dart';
import 'shopping_list_page.dart'; // yeni sayfa oluşturacağız

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff001F3F),
        title: Row(
          children: [
            Image.asset(
              'assets/projelogosu.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text("Aldım Gitti", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingListPage()),
                );
              },
              label: const Text('Alışveriş Listesi'),
              icon: const Icon(Icons.shopping_cart),
              backgroundColor: const Color(0xff001F3F),
            ),
          ),
        ],
      ),
    );
  }
}
