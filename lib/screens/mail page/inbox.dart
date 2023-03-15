import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/mail page/mail.dart';
import 'package:flutter/material.dart';
import 'package:kyo/screens/mail page/generating_page.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Inbox extends StatefulWidget {
  @override
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _Inbox();
}

class _Inbox extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(
                child: Text(
              "Inbox",
              style: TextStyle(fontSize: 24),
            )),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "abv@gmail.com",
                      prefixIcon: Image.asset("assets/images/Mail.png"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  )),
              SizedBox(
                  width:
                      45), // add some spacing between the text field and button
              Material(
                elevation: 10,
                shadowColor: Color(0xFFF62F53),
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.search),
                  backgroundColor: Color(0xFFF62F53),
                  foregroundColor: Colors.white,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Inbox",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          FutureBuilder<List>(
              future: GoogleService.getEmails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List emails = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: emails.length + 1,
                        itemBuilder: (BuildContext context, index) {
                          return (index == 0)
                              ? SizedBox(
                                  height: 0,
                                )
                              : GestureDetector(
                                  onTap: () {},
                                  child: Mail(
                                    email: emails[index - 1],
                                  ));
                        }),
                  );
                } else {
                  return LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: [Color(0xFFF62F53)],
                    strokeWidth: 2,
                  );
                }
              })
        ],
      ),
    );
  }
}
