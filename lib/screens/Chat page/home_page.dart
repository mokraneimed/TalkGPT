import 'package:flutter/material.dart';
import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/Chat%20page/chat.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:kyo/screens/mail%20page/inbox.dart';
import 'package:kyo/screens/Home%20page/home.dart';
import 'package:loading_indicator/loading_indicator.dart';

List pages = [LandPage(), Inbox(), ChatPage()];

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
      setState(() {
        signError = false;
      });
      success = await GoogleService.signInSilentlyWithGoogle();
    } catch (e) {
      print(e.toString());
    } finally {
      if (success == true) {
        setState(() {
          GoogleService.signedIn = true;
        });
      } else {
        setState(() {
          signError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Problem while signing in. Check connection")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (!GoogleService.signedIn && !signError) {
      signSilent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'lato regular'),
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
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'lato regular'),
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
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'lato regular'),
                  ),
                ),

                /// Profile
              ],
            ),
            body: pages[_currentIndex])
        : Scaffold(
            body: Stack(
              children: [
                // (signError)
                //     ? const Positioned(
                //         bottom: 10,
                //         child: Align(
                //             alignment: Alignment.center,
                //             child: SnackBar(
                //                 content: Text("Error while signing in"))))
                //     : SizedBox(),
                Center(
                    child: Container(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/black_logo.png"),
                      (!signError)
                          ? Container(
                              height: 40,
                              width: 40,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.circleStrokeSpin,
                                colors: [Color(0xFFF62F53)],
                                strokeWidth: 2,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                signSilent();
                              },
                              child: CircleAvatar(
                                radius: width * 0.1,
                                backgroundColor: const Color(0xFFF62F53),
                                child: Image.asset(
                                  "assets/images/refresh.png",
                                  width: width * 0.1,
                                ),
                              ),
                            )
                    ],
                  ),
                )),
              ],
            ),
          );
  }
}
