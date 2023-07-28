import 'package:flutter/material.dart';
import 'package:kyo/emails_request.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatelessWidget {
  final VoidCallback onClicked;
  const SignUpPage({Key? key, required this.onClicked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.32),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo.png",
                  )),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.08),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '''State-Of-The-Art
Virtual Assistant''',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontFamily: 'bold'),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          '''TalkGPT is based on the powerful OpenAI’s
large language model GPT 3.5 Turbo.''',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'regular'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: height * 0.05,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(width * 0.58, height * 0.08),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        GoogleService.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/images/google_logo.png",
                            width: width * 0.06,
                          ),
                          Text(
                            "Login with google",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontFamily: 'lato regular'),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
