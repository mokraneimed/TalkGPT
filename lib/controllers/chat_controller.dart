import 'package:flutter/material.dart';
import 'package:kyo/request.dart';

class ChatController extends ChangeNotifier {
  static List prompts = [];
  static DataService dataService = DataService();
  static List questions = [];
  static String response = '';
  static List responses = [];
  static bool isLoading = false;
  static TextEditingController messageController = TextEditingController();

  void sendRequest(BuildContext context) async {
    String prompt = messageController.text;
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 20), () async {
      try {
        prompts.add({"role": "user", "content": '$prompt'});
        questions.insert(0, prompt);
        response = await dataService.sendRequestChat(prompts);
      } catch (e) {
      } finally {
        if (response != '') {
          responses.insert(0, response);
          prompts.add({"role": "system", "content": '$response'});
          isLoading = false;
          messageController.text = '';
          notifyListeners();
        } else {
          prompts.removeLast();
          questions.removeAt(0);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Error while regenerating the response. Check connection, hadi t333")));
          isLoading = false;
          notifyListeners();
        }
      }
    });
  }
}
