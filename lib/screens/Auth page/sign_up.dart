import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kyo/screens/Auth page/text_field.dart';
import 'package:kyo/screens/Chat%20page/home_page.dart';
import 'package:kyo/emails_request.dart';

class SignUpPage extends StatelessWidget {
  final VoidCallback onClicked;
  const SignUpPage({Key? key, required this.onClicked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F2F6),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo.png")),
          SizedBox(
            height: 60,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Sign in",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(),
          SizedBox(
            height: 20,
          ),
          CustomTextField(),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF62F53),
                  fixedSize: const Size(240, 70),
                  elevation: 10,
                  shadowColor: Color(0xFFF62F53),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    "Sign in",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Image.asset("assets/images/circle_arrow.png")
                ],
              )),
          SizedBox(
            height: 40,
          ),
          Text(
            "OR",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: const Size(240, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                GoogleService.signInWithGoogle();
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset("assets/images/google_logo.png"),
                  SizedBox(width: 20),
                  Text(
                    "Login with google",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  text: 'Don\'t have an account ?',
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = onClicked,
                    text: '  Sign up',
                    style: TextStyle(color: Color(0xFFF62F53), fontSize: 18))
              ]))
        ],
      ),
    );
  }
}
