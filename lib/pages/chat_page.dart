import 'package:flutter/material.dart';
import '../services/asistan_servisi.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // {role: "user/ai", content: "..."}

  Future<void> _gonder() async {
    final mesaj = _controller.text.trim();
    if (mesaj.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": mesaj});
      _controller.clear();
    });

    final yanit = await _asistanYanitiUret(mesaj);

    setState(() {
      _messages.add({"role": "ai", "content": yanit});
    });
  }

  Future<String> _asistanYanitiUret(String mesaj) async {
    return await AsistanServisi.sohbetEt(mesaj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧠 Akıllı Asistan"),
        backgroundColor: Color.fromARGB(255, 240, 242, 245),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["content"] ?? ""),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Mesaj yaz...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _gonder,
                  color: Colors.blue,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
