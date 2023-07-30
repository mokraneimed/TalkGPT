import 'package:flutter/material.dart';
import 'package:kyo/controllers/chat_controller.dart';
import 'package:provider/provider.dart';
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
  String generatedText = '';
  late sst.SpeechToText _speech;
  bool isListening = false;

  List prompts = [];
  List responses = [];
  bool isLoading = false;

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
                ChatController.messageController.text = val.recognizedWords;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<ChatController>(
          builder: (context, chatController, children) {
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: 300,
                                    child: Text(
                                      ChatController.questions[index - 1],
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
                                            width: 1,
                                            color: Color(0xFFDADADA))),
                                    width: 300,
                                    child: Text(
                                      ChatController.responses[index - 1],
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
                                child: TextField(
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "tap mic or type",
                                      hintStyle:
                                          TextStyle(color: Colors.white54)),
                                  controller: ChatController.messageController,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            );
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return SizedBox(
                        height: 0,
                      );
                    },
                    itemCount: ChatController.questions.length + 1),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!isLoading) {
                        chatController.sendRequest();
                      }
                    },
                    child: (!ChatController.isLoading)
                        ? Material(
                            elevation: 10.0,
                            shadowColor: Color(0xFFF62F53),
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: (!isLoading)
                                  ? Colors.white
                                  : Colors.grey[700],
                              child: Icon(
                                Icons.send,
                                color: Colors.black,
                              ),
                              radius: 30.0,
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            child: const LoadingIndicator(
                              indicatorType: Indicator.circleStrokeSpin,
                              colors: [Color(0xFFF62F53)],
                              strokeWidth: 2,
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
      }),
    );
  }
}
