import 'package:flutter/material.dart';
import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/Chat%20page/chat.dart';

class LandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 27, 26, 26),
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
                  top: 52,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: width * 0.06,
                        backgroundImage: NetworkImage(GoogleService.photoURL!),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GoogleService.username!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lato regular'),
                          ),
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
                    left: width * 0.28,
                    bottom: 90,
                    child: SizedBox(
                        height: height * 0.06,
                        child: Image.asset(
                          "assets/images/black_logo.png",
                          fit: BoxFit.contain,
                        ))),
                Positioned(
                    bottom: 30,
                    left: 55,
                    child: Container(
                      width: 300,
                      child: const Text(
                        "Engage in a suggested discussion by the Virtual Assistant based on your interests. ",
                        style:
                            TextStyle(fontSize: 16, fontFamily: "lato regular"),
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
              ],
            ),
          ],
        ));
  }
}
