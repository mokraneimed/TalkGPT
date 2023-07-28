import 'package:kyo/emails_request.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../request.dart';

class EmailGenerator extends ChangeNotifier {
  static String response = '';
  static bool loading = false;
  static bool emailGenerated = false;
  static DataService dataService = DataService();
  static TextEditingController responseController = TextEditingController();
  static List prompts = [];

  void init() {
    response = '';
    loading = false;
    dataService = DataService();
    responseController = TextEditingController();
    emailGenerated = false;
    prompts = [];
  }

  void sendEmail() async {
    await GoogleService.testingEmail("li_mokrane@esi.dz");
  }

  void generate(String message) async {
    loading = true;
    prompts.add({
      "role": "user",
      "content": 'Generate a response for this email: $message'
    });
    notifyListeners();
    try {
      response = await dataService.sendRequestChat(prompts);
      responseController.text = response;
    } catch (e) {
      print(e.toString());
    } finally {
      loading = false;
      emailGenerated = true;
      prompts.add({"role": "system", "content": '$response'});
      notifyListeners();
    }
  }

  void regenrate() async {
    loading = true;
    prompts.add({"role": "user", "content": 'Regenrate the response'});
    notifyListeners();
    try {
      response = await dataService.sendRequestChat(prompts);
      responseController.text = response;
    } catch (e) {
      print(e.toString());
    } finally {
      loading = false;
      prompts.add({"role": "system", "content": '$response'});
      notifyListeners();
    }
  }
}
