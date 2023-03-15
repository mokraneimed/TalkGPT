import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kyo/screens/Auth page/login.dart';
import 'package:kyo/screens/Auth page/sign_up.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
      isLogin ? SignUpPage(onClicked: toggle) : LoginPage(onClicked: toggle);
  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
