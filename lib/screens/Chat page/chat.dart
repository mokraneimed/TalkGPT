import 'package:flutter/material.dart';
import 'package:kyo/controllers/chat_controller.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:kyo/request.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:native_ads_flutter/native_ads.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:kyo/ads_manager.dart';
import 'package:sizer/sizer.dart';

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
  final nativeAdController = NativeAdmobController();
  AdmobInterstitial? interstitialAd;

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
    interstitialAd = AdmobInterstitial(
        adUnitId: AdsManager.interstitialAdUnit,
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
          if (event == AdmobAdEvent.closed) interstitialAd!.load();
        });
    interstitialAd!.load();
    nativeAdController.reloadAd(forceRefresh: true);
  }

  @override
  void dispose() {
    interstitialAd!.dispose();
    nativeAdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!ChatController.isLoading) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Consumer<ChatController>(
          builder: (context, chatController, children) {
        return Scaffold(
            body: Container(
          height: height * 0.92,
          child: Column(
            children: [
              Container(
                height: 90,
                padding: EdgeInsets.only(top: height * 0.07),
                child: Center(
                    child: Text(
                  "Voice GPT",
                  style: TextStyle(fontSize: 18.sp, fontFamily: 'lato regular'),
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
                                    margin: EdgeInsets.fromLTRB(
                                        0, 0, width * 0.02, height * 0.02),
                                    padding: EdgeInsets.all(width * 0.035),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF62F53),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: width * 0.75,
                                    child: Text(
                                      ChatController.questions[index - 1],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: 'lato regular'),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        width * 0.02, 0, 0, height * 0.02),
                                    padding: EdgeInsets.all(width * 0.035),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.035),
                                        border: Border.all(
                                            width: 1,
                                            color: Color(0xFFDADADA))),
                                    width: width * 0.75,
                                    child: Text(
                                      ChatController.responses[index - 1],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontFamily: 'lato regular'),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    0, 0, width * 0.02, height * 0.02),
                                padding: EdgeInsets.all(width * 0.035),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF62F53),
                                    borderRadius: BorderRadius.circular(20)),
                                width: width * 0.75,
                                child: TextField(
                                  maxLines: null,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "tap mic or type",
                                      hintStyle: TextStyle(
                                          color: Colors.white54,
                                          fontFamily: 'lato regular')),
                                  controller: ChatController.messageController,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontFamily: 'lato regular'),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (!isLoading) {
                        chatController.sendRequest(context);
                        interstitialAd!.show();
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
                              // b9awli 8 hna
                              radius: width * 0.075,
                            ),
                          )
                        : Container(
                            height: width * 0.11,
                            width: width * 0.11,
                            child: const LoadingIndicator(
                              indicatorType: Indicator.circleStrokeSpin,
                              colors: [Color(0xFFF62F53)],
                              strokeWidth: 2,
                            ),
                          ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  GestureDetector(
                    onTap: onListen,
                    child: AvatarGlow(
                      glowColor: Color(0xFFF62F53),
                      animate: _speech.isListening,
                      endRadius: width * 0.14,
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
                            height: width * 0.06,
                            width: width * 0.06,
                          ),
                          radius: width * 0.075,
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
