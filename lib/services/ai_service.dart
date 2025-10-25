import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Update these for your API provider
  static String baseUrl = "https://api.openai.com/v1/chat/completions";
  static String apiKey = ""; // <- put key or load from env

  static Future<String> summarize(String text) async {
    if (apiKey.isEmpty) {
      // Fallback: simple local "summary"
      final trimmed = text.trim();
      if (trimmed.length <= 200) return trimmed;
      return '${trimmed.substring(0, 200)}...';
    }
    final body = {
      "model": "gpt-4o-mini",
      "messages": [
        {"role": "system", "content": "Summarize the user's note in 3-5 bullet points."},
        {"role": "user", "content": text}
      ],
      "temperature": 0.3,
    };
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final content = json["choices"][0]["message"]["content"] as String?;
      return content ?? "No summary.";
    } else {
      return "Summary unavailable (HTTP ${res.statusCode}).";
    }
  }
}
