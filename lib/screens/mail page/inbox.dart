import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:kyo/controllers/email_genearator_controller.dart';
import 'package:kyo/emails_request.dart';
import 'package:kyo/screens/mail page/mail.dart';
import 'package:flutter/material.dart';
import 'package:kyo/screens/mail page/generating_page.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class Inbox extends StatefulWidget {
  @override
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _Inbox();
}

class _Inbox extends State<Inbox> {
  ScrollController scrollController = ScrollController();
  EmailGenerator emailGenerator = EmailGenerator();
  CancelableOperation? cancelableMethod;
  bool fetch = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<EmailGenerator>(builder: (context, emailGenerator, child) {
      if ((fetch) /*&& (GoogleService.firstFetch)*/) {
        Future.delayed(Duration(milliseconds: 0), () {
          EmailGenerator.fromCancelable(emailGenerator.loadMoreEmails());
          fetch = false;
        });
      }

      scrollController.addListener(() {
        var triggerFetchMoreSize =
            0.9999 * scrollController.position.maxScrollExtent;
        if ((scrollController.position.pixels > triggerFetchMoreSize) &&
            (!EmailGenerator.emailsLoading)) {
          emailGenerator.loadMoreEmails();
        }
      });
      return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.08),
              child: Center(
                  child: Text(
                "Inbox",
                style: TextStyle(fontSize: 24, fontFamily: 'lato regular'),
              )),
            ),
            SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Row(children: [
            //     Container(
            //         margin: EdgeInsets.only(left: 10),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(12)),
            //         width: 250,
            //         child: TextField(
            //           decoration: InputDecoration(
            //             hintText: "abv@gmail.com",
            //             prefixIcon: Image.asset("assets/images/Mail.png"),
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(30)),
            //           ),
            //         )),
            //     SizedBox(
            //         width:
            //             45), // add some spacing between the text field and button
            //     Material(
            //       elevation: 10,
            //       shadowColor: Color(0xFFF62F53),
            //       shape: CircleBorder(),
            //       child: CircleAvatar(
            //         radius: 28,
            //         child: Icon(Icons.search),
            //         backgroundColor: Color(0xFFF62F53),
            //         foregroundColor: Colors.white,
            //       ),
            //     ),
            //   ]),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 30),
            //     child: Text(
            //       "Inbox",
            //       style: TextStyle(fontSize: 24),
            //     ),
            //   ),
            // ),

            Expanded(
                child: RefreshIndicator(
              color: const Color(0xFFF62F53),
              onRefresh: () async {
                Future.delayed(const Duration(milliseconds: 20), () async {
                  GoogleService.firstFetch = true;
                  GoogleService.lastToken = null;
                  await emailGenerator.loadMoreEmails();
                });
              },
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: GoogleService.emails.length + 1,
                  itemBuilder: ((BuildContext context, index) {
                    return (index == GoogleService.emails.length)
                        ? (EmailGenerator.emailsLoading)
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 170),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.circleStrokeSpin,
                                    colors: [Color(0xFFF62F53)],
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : (EmailGenerator.loadingError)
                                ? GestureDetector(
                                    onTap: () async {
                                      await emailGenerator.loadMoreEmails();
                                    },
                                    child: CircleAvatar(
                                      radius: width * 0.06,
                                      backgroundColor: const Color(0xFFF62F53),
                                      child: Image.asset(
                                        "assets/images/refresh.png",
                                        width: width * 0.06,
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                        : GestureDetector(
                            onTap: () {},
                            child: Mail(
                              email: GoogleService.emails[index],
                            ));
                  })),
            )),

            // StreamBuilder<List>(
            //     stream: emailGenerator.loadMoreEmails(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         final List emails = snapshot.data!;
            //         return Expanded(
            //           child: ListView.builder(
            //               controller: scrollController,
            //               itemCount: emails.length + 2,
            //               itemBuilder: (BuildContext context, index) {
            //                 return (index == 0)
            //                     ? SizedBox(
            //                         height: 0,
            //                       )
            //                     : (index == emails.length + 1)
            //                         ? (EmailGenerator.emailsLoading)
            //                             ? const SizedBox(
            //                                 height: 50,
            //                                 width: 50,
            //                                 child: LoadingIndicator(
            //                                   indicatorType:
            //                                       Indicator.circleStrokeSpin,
            //                                   colors: [Color(0xFFF62F53)],
            //                                   strokeWidth: 2,
            //                                 ),
            //                               )
            //                             : const SizedBox()
            //                         : GestureDetector(
            //                             onTap: () {},
            //                             child: Mail(
            //                               email: emails[index - 1],
            //                             ));
            //               }),
            //         );
            //       } else {
            //         return SizedBox(
            //           height: 50,
            //           width: 50,
            //           child: LoadingIndicator(
            //             indicatorType: Indicator.circleStrokeSpin,
            //             colors: [Color(0xFFF62F53)],
            //             strokeWidth: 2,
            //           ),
            //         );
            //       }
            //     }),
          ],
        ),
      );
    });
  }
}
