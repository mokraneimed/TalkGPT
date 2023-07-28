import 'package:flutter/material.dart';
import 'package:kyo/controllers/email_genearator_controller.dart';
import 'package:kyo/screens/mail page/generating_page.dart';
import 'package:provider/provider.dart';

class Mail extends StatelessWidget {
  String email;
  Mail({required this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: (ListTile(
        leading: CircleAvatar(
          child: Text('A'),
        ),
        title: Text('Email Title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "imed mokrane",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('10:45 AM'),
            Icon(Icons.star_border),
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
