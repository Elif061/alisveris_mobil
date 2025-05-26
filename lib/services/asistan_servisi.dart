import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsistanServisi {
  static const String apiKey =
      "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";
  static const String apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  static Future<String> sohbetEt(String mesaj) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "Kısa, net, açıklayıcı, Türkçe cevaplar ver. Kullanıcı market ürünleri, yemek önerileri, kalori bilgisi veya indirimli ürünleri sorabilir."
            },
            {"role": "user", "content": mesaj},
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data["choices"][0]["message"]["content"];
      } else {
        return "Sunucu hatası: ${response.statusCode}";
      }
    } catch (e) {
      return "İstek hatası: $e";
    }
  }
}
