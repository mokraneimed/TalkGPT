import 'package:kyo/emails_request.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;

import '../request.dart';

class EmailGenerator extends ChangeNotifier {
  static String response = '';
  static bool available = false;
  static bool loading = false;
  static bool emailGenerated = false;
  static DataService dataService = DataService();
  static TextEditingController responseController = TextEditingController();
  static List prompts = [];
  static TextEditingController promptController = TextEditingController();

  static sst.SpeechToText speech = sst.SpeechToText();
  static bool isListening = false;

  void init() {
    available = false;
    speech = sst.SpeechToText();
    response = '';
    loading = false;
    dataService = DataService();
    responseController = TextEditingController();
    promptController = TextEditingController();
    emailGenerated = false;
    prompts = [];
    isListening = false;
  }

  void sendRequestEmail(String message) async {
    String prompt = promptController.text;
    loading = true;
    if (responseController.text.isEmpty) {
      prompts.add({"role": "user", "content": '$prompt \n$message'});
    } else {
      prompts.add({"role": "user", "content": prompt});
    }
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

  void onListen() async {
    if (!available) {
      available = await speech.initialize(
          onStatus: (val) => print('on status $val'),
          onError: (val) => print("on error $val"));
    }
    notifyListeners();
    if (available) {
      speech.listen(onResult: (val) {
        promptController.text = val.recognizedWords;
        notifyListeners();
      });
    }
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
