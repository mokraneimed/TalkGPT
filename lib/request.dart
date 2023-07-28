import 'dart:convert';

import 'package:http/http.dart' as http;

final String apiUrl = "https://api.openai.com/v1/chat/completions";
final String apiKey = "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";

class DataService {
  bool isLoading = false;
  Future<String> sendRequest(String prompt) async {
    isLoading = true;

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": '$prompt'}
          ],
        }));

    isLoading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String text = data['choices'][0]['message']['content'];
      print(text);
      return text;
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<String> sendRequestChat(List prompts) async {
    isLoading = true;

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": prompts,
        }));

    isLoading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String text = data['choices'][0]['message']['content'];
      print(text);
      return text;
    } else {
      throw Exception('Failed to send request');
    }
  }
}
