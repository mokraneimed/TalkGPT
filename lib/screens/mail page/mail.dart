import 'package:flutter/material.dart';
import 'package:kyo/controllers/email_genearator_controller.dart';
import 'package:kyo/screens/mail page/generating_page.dart';
import 'package:kyo/screens/models/email.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../colors.dart';

class Mail extends StatelessWidget {
  Email email;
  Mail({required this.email});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: (ListTile(
        leading: (email.photoUrl == null)
            ? CircleAvatar(
                backgroundColor: colors[email.profileColor!],
                radius: width * 0.06,
                child: (email.senderName![0] == "\"")
                    ? Text(
                        email.senderName![1],
                        style: TextStyle(fontSize: 17.sp, color: Colors.white),
                      )
                    : Text(
                        email.senderName![0],
                        style: TextStyle(fontSize: 17.sp, color: Colors.white),
                      ))
            : CircleAvatar(
                radius: width * 0.06,
                backgroundImage: NetworkImage(email.photoUrl!),
              ),
        title: Text(
          email.subject!,
          style: TextStyle(fontFamily: 'lato regular'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.senderName!,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'lato regular'),
            ),
            Text(
              email.message!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontFamily: 'lato regular'),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "10:45 AM",
              style: TextStyle(fontFamily: 'lato regular'),
            ),
          ],
        ),
        onTap: () {
          context.read<EmailGenerator>().init();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GenPage(
                      message: email,
                    )),
          );
        },
      )),
    );
  }
}
