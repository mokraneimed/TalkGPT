import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:kyo/controllers/email_genearator_controller.dart';
import 'package:kyo/request.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

String email =
    "Greetings,\n\nWe’re delighted to have you as an accepted participant for JunctionX Algiers this year.  This edition of Junction is hybrid meaning that it is divided into two parts, the first will be online and will go on from Thursday evening March 9th throughout the weekend to Saturday night March 11th. The teams with the best projects will then be selected to participate in the physical event that will happen at ICT Maghreb at the Palace of Culture Moufdi Zakaria on March 14-16th 2023.";

DataService dataService = DataService();
String first_email = email;

class GenPage extends StatefulWidget {
  String message;
  GenPage({required this.message});

  @override
  State<GenPage> createState() => _GenPage(message: message);
}

class _GenPage extends State<GenPage> {
  String response = '';
  String message;
  _GenPage({required this.message});

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<EmailGenerator>(
        builder: (context, emailGenerator, children) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                      SizedBox(
                        height: 200,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(18, 0, 17, 50),
                              child: Text(
                                message,
                                style: TextStyle(
                                    fontSize: 10.5.sp,
                                    fontFamily: 'lato regular'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (EmailGenerator.response != '')
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(18, 0, 17, 200),
                                width: 320,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  toolbarOptions: const ToolbarOptions(
                                    copy: true,
                                    selectAll: true,
                                    paste: true,
                                  ),
                                  readOnly: false,
                                  maxLines: null,
                                  controller: EmailGenerator.responseController,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                      fontSize: 10.5.sp,
                                      fontFamily: 'lato regular',
                                      color: Colors.black),
                                ),
                              ),
                            )
                          : SizedBox()
                    ]),
                  )
                ],
              ),
              (EmailGenerator.emailGenerated == false)
                  ? (EmailGenerator.loading == false)
                      ? Positioned(
                          bottom: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            width: width,
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF62F53),
                                    fixedSize: const Size(120, 40),
                                    elevation: 10,
                                    shadowColor: Color(0xFFF62F53),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: () {
                                  emailGenerator.generate(message);
                                },
                                child: Text("reply to this mail")),
                          ),
                        )
                      : Positioned(
                          bottom: 12,
                          child: Container(
                            height: 40,
                            width: 40,
                            child: const LoadingIndicator(
                              indicatorType: Indicator.circleStrokeSpin,
                              colors: [Color(0xFFF62F53)],
                              strokeWidth: 2,
                            ),
                          ),
                        )
                  : Positioned(
                      bottom: 0,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              (!EmailGenerator.loading)
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFF62F53),
                                          fixedSize: const Size(120, 40),
                                          elevation: 10,
                                          shadowColor: Color(0xFFF62F53),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12))),
                                      onPressed: () {
                                        emailGenerator.regenrate();
                                      },
                                      child: Text("regenrate"))
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      child: const LoadingIndicator(
                                        indicatorType:
                                            Indicator.circleStrokeSpin,
                                        colors: [Color(0xFFF62F53)],
                                        strokeWidth: 2,
                                      ),
                                    ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    fixedSize: const Size(120, 40),
                                    elevation: 10,
                                    shadowColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: () {
                                  emailGenerator.sendEmail();
                                },
                                child: Text(
                                  "send email",
                                  style: TextStyle(color: Color(0xFFF62F53)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: AvatarGlow(
                                  glowColor: Color(0xFFF62F53),
                                  animate: false,
                                  endRadius: 60.0,
                                  child: Material(
                                    elevation: 8.0,
                                    shadowColor: Color(0xFFF62F53),
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
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
                          )
                        ],
                      ))
            ],
          ),
        ),
      );
    });
  }
}
