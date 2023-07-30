import 'package:flutter/material.dart';
import 'package:kyo/request.dart';

class ChatController extends ChangeNotifier {
  static List prompts = [];
  static DataService dataService = DataService();
  static List questions = [];
  static String response = '';
  static List responses = [];
  static bool isLoading = false;

  void sendRequest(String prompt) async {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 20), () async {
      try {
        prompts.add({"role": "user", "content": '$prompt'});
        questions.insert(0, prompt);
        response = await dataService.sendRequestChat(prompts);
      } catch (e) {
      } finally {
        responses.insert(0, response);
        prompts.add({"role": "system", "content": '$response'});
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
