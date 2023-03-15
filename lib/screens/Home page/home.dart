import 'package:flutter/material.dart';
import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/Chat%20page/chat.dart';

class LandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 270,
                  child: Image.asset(
                    "assets/images/Rectangle.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 45,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 25,
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Imed Edddine Mokrane',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Student")
                        ],
                      ),
                      SizedBox(width: 40),
                      GestureDetector(
                          onTap: () {
                            GoogleService.signOut();
                          },
                          child: Image.asset("assets/images/go.png"))
                    ],
                  ),
                ),
                Positioned(
                    left: 110,
                    bottom: 90,
                    child: Image.asset("assets/images/logo.png")),
                Positioned(
                    bottom: 30,
                    left: 55,
                    child: Container(
                      width: 300,
                      child: Text(
                        "Engage in a suggested discussion by the Virtual Assistant based on your interests. ",
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 471,
                  width: double.infinity,
                  child: GestureDetector(
                    child: Image.asset(
                      "assets/images/robot.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 105,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF62F53),
                          fixedSize: const Size(190, 60),
                          elevation: 10,
                          shadowColor: Color(0xFFF62F53),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Get Started",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.mic,
                            color: Colors.white,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ],
        ));
  }
}
