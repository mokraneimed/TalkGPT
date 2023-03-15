import 'package:flutter/material.dart';
import 'package:kyo/request.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(40)),
                          width: 320,
                          child: Text(
                            message,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF62F53),
                              fixedSize: const Size(120, 40),
                              elevation: 10,
                              shadowColor: Color(0xFFF62F53),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: generate,
                          child: Text("generate")),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (response != '')
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(40)),
                        width: 320,
                        child: Text(
                          response,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : SizedBox()
            ]),
          )
        ],
      ),
    );
  }

  void generate() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  height: 175,
                  width: 175,
                  child: LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: [Color(0xFFF62F53)],
                    strokeWidth: 2,
                  )));
        });
    response = await dataService
        .sendRequest("Generate a response to this email:\n" + message);

    Navigator.of(context).pop();
    setState(() {});
  }
}
