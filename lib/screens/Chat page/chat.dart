import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:kyo/request.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_indicator/loading_indicator.dart';

final dataService = DataService();

class ChatPage extends StatefulWidget {
  @override
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final FlutterTts player = FlutterTts();
  String generatedText = '';
  late sst.SpeechToText _speech;
  bool isListening = false;
  String textSpeech = "\"tap mic to start a conversation\"";
  List prompts = [];
  List responses = [];
  bool isLoading = false;

  void speak(String text) async {
    await player.setLanguage("en-US");
    await player.setVoice({"name": "John", "locale": "en-AU"});
    await player.setPitch(1);
    await player.speak(text);
  }

  void onListen() async {
    bool available = await _speech.initialize(
        onStatus: (val) => print('on status $val'),
        onError: (val) => print("on error $val"));
    if (available) {
      setState(() {
        isListening = true;
      });
      _speech.listen(
          onResult: (val) => setState(() {
                textSpeech = val.recognizedWords;
              }));
    }
  }

  @override
  void initState() {
    super.initState();

    _speech = sst.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: 725,
      child: Column(
        children: [
          Container(
            height: 90,
            padding: EdgeInsets.only(top: 60),
            child: Center(
                child: Text(
              "Voice GPT",
              style: TextStyle(fontSize: 24),
            )),
          ),
          Expanded(
            child: ListView.separated(
                reverse: true,
                itemBuilder: (BuildContext context, index) {
                  return (!(index == 0))
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 25),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF62F53),
                                    borderRadius: BorderRadius.circular(20)),
                                width: 300,
                                child: Text(
                                  prompts[index - 1],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 25),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 1, color: Color(0xFFDADADA))),
                                width: 300,
                                child: Text(
                                  responses[index - 1],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 5),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Color(0xFFF62F53),
                                borderRadius: BorderRadius.circular(20)),
                            width: 300,
                            child: Text(
                              textSpeech,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        );
                },
                separatorBuilder: (BuildContext context, index) {
                  return SizedBox(
                    height: 0,
                  );
                },
                itemCount: prompts.length + 1),
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () async {
                  if (!isLoading) {
                    prompts.insert(0, textSpeech);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                  height: 175,
                                  width: 175,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.circleStrokeSpin,
                                    colors: [Color(0xFFF62F53)],
                                    strokeWidth: 2,
                                  )));
                        });

                    final text = await dataService
                        .sendRequest(generatedText + "\n" + textSpeech);
                    Navigator.of(context).pop();
                    textSpeech = '';
                    setState(() {
                      generatedText = text;
                      responses.insert(0, text);
                      speak(text);
                      isLoading = false;
                    });
                  }
                },
                child: Material(
                  elevation: 10.0,
                  shadowColor: Color(0xFFF62F53),
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor:
                        (!isLoading) ? Colors.white : Colors.grey[700],
                    child: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    radius: 30.0,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: onListen,
                child: AvatarGlow(
                  glowColor: Color(0xFFF62F53),
                  animate: _speech.isListening,
                  endRadius: 60.0,
                  child: Material(
                    elevation: 8.0,
                    shadowColor: Color(0xFFF62F53),
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: (!_speech.isListening)
                          ? Colors.white
                          : Color(0xFFF62F53),
                      child: Image.asset(
                        "assets/images/mic.png",
                        height: 24,
                        width: 24,
                      ),
                      radius: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
