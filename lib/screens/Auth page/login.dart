import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kyo/screens/Auth page/text_field.dart';
import 'package:kyo/screens/Chat%20page/home_page.dart';
import 'package:kyo/emails_request.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onClicked;
  const LoginPage({Key? key, required this.onClicked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 30,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30),
              child: Icon(Icons.arrow_back),
            )),
        SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              "Sign up",
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
          height: 20,
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
                  width: 60,
                ),
                Text(
                  "Sign up",
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
                text: 'Already have an account ?',
                children: [
              TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = onClicked,
                  text: '  Sign in',
                  style: TextStyle(color: Color(0xFFF62F53), fontSize: 18))
            ]))
      ]),
    );
  }
}
