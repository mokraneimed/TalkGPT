import 'package:flutter/material.dart';
import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/Chat%20page/chat.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:kyo/screens/mail%20page/inbox.dart';
import 'package:kyo/screens/Home%20page/home.dart';
import 'package:loading_indicator/loading_indicator.dart';

List pages = [LandPage(), Inbox(), ChatPage(), Container()];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  var _currentIndex = 0;
  bool signedIn = false;
  bool signError = false;

  void signSilent() async {
    bool? success;
    try {
      success = await GoogleService.signInSilentlyWithGoogle();
    } catch (e) {
      print(e.toString());
    } finally {
      if (success == true) {
        setState(() {
          signError = false;
          GoogleService.signedIn = true;
        });
      } else {
        setState(() {
          signError = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (!GoogleService.signedIn) {
        signSilent();
      }
    });
    return (GoogleService.signedIn)
        ? Scaffold(
            bottomNavigationBar: SalomonBottomBar(
              selectedColorOpacity: 0.9,
              selectedItemColor: Color(0xFFF62F53),
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [
                SalomonBottomBarItem(
                  icon: (_currentIndex == 0)
                      ? Image.asset(
                          "assets/images/sel_home.png",
                          height: 24,
                          width: 24,
                        )
                      : Image.asset(
                          "assets/images/uns_home.png",
                          height: 24,
                          width: 24,
                        ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: (_currentIndex == 1)
                      ? Image.asset(
                          "assets/images/sel_mail.png",
                          height: 24,
                          width: 24,
                        )
                      : Image.asset(
                          "assets/images/uns_mail.png",
                          height: 24,
                          width: 24,
                        ),
                  title: Text(
                    "Mail",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                /// Search
                SalomonBottomBarItem(
                  icon: (_currentIndex == 2)
                      ? Image.asset(
                          "assets/images/sel_robot.png",
                          height: 24,
                          width: 24,
                        )
                      : Image.asset(
                          "assets/images/uns_chat.png",
                          height: 24,
                          width: 24,
                        ),
                  title: Text(
                    "Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: (_currentIndex == 3)
                      ? Image.asset(
                          "assets/images/sel_profile.png",
                          height: 24,
                          width: 24,
                        )
                      : Image.asset(
                          "assets/images/uns_profile.png",
                          height: 24,
                          width: 24,
                        ),
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: pages[_currentIndex])
        : Scaffold(
            body: Stack(
              children: [
                (signError)
                    ? const Positioned(
                        bottom: 10,
                        right: 0,
                        left: 0,
                        child: Text("error in signing"))
                    : SizedBox(),
                Center(
                    child: Container(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/black_logo.png"),
                      Container(
                        height: 40,
                        width: 40,
                        child: const LoadingIndicator(
                          indicatorType: Indicator.circleStrokeSpin,
                          colors: [Color(0xFFF62F53)],
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
  }
}
