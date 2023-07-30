import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyo/screens/models/email.dart';

class GoogleService {
  static List emails = [];
  static GoogleSignIn? googleUser;
  static UserCredential? user;
  static signInWithGoogle() async {
    try {
      googleUser = await GoogleSignIn(
          scopes: [GmailApi.gmailReadonlyScope, GmailApi.gmailSendScope]);

      GoogleSignInAccount? account = await googleUser!.signIn();
      if (googleUser == null) {
        throw Exception('Sign in aborted by user');
      }
      GoogleSignInAuthentication? googleAuth = await account?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      user = await FirebaseAuth.instance.signInWithCredential(credential);
      print(user?.user?.displayName);
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  static Future<List> getEmails() async {
    try {
      final authClient = await googleUser!.authenticatedClient();
      final gmailApi = GmailApi(authClient!);
      final email = FirebaseAuth.instance.currentUser?.email;
      final messages_ids =
          await gmailApi.users.messages.list(email!, maxResults: 10);
      for (final message in messages_ids.messages!) {
        final msg = await gmailApi.users.messages.get(email, message.id!);
        final payload = msg.payload;
        final parts = payload!.parts;
        String? subject = payload.headers!
            .firstWhereOrNull(
              (header) => header.name == "Subject",
            )!
            .value;
        print(subject);
        String? fromInfo = payload.headers!
            .firstWhereOrNull((header) => header.name == "From")!
            .value;
        print(fromInfo);
        List<String> _fromInfo = fromInfo!.split("\u003c");
        print(_fromInfo[0]);
        List<String> senderEmail = _fromInfo[1].split("\u003e");
        print(senderEmail[0]);
        String? inReplyTo;
        String? messageID;
        String? refrences;
        try {
          inReplyTo = payload.headers!
              .firstWhere((header) => header.name == "In-Reply-To")
              .value;
        } catch (e) {
          inReplyTo = null;
        }

        print(inReplyTo);
        try {
          messageID = payload.headers!
              .firstWhere((header) => header.name == "Message-ID")
              .value;
        } catch (e) {
          messageID = null;
        }
        print(messageID);
        try {
          refrences = payload.headers!
              .firstWhere((header) => header.name == "Refrences")
              .value;
        } catch (e) {
          refrences = null;
        }
        print(refrences);
        if (parts == null) {
          if (payload.mimeType == "text/plain") {
            List<int> decodedBytes = base64Url.decode(payload.body!.data!);
            String decodedString = utf8.decode(decodedBytes);
            final Email email = Email(
                message: decodedString,
                subject: subject,
                senderName: _fromInfo[0],
                senderEmail: senderEmail[0],
                messageID: messageID,
                refrences: refrences,
                inReplyTo: inReplyTo);
            emails.add(email);
          }
        } else {
          for (final part in parts) {
            final body = part.body;
            final data = body!.data;
            final mimeType = part.mimeType;
            if (mimeType == "text/plain") {
              List<int> decodedBytes = base64Url.decode(data!);
              String decodedString = utf8.decode(decodedBytes);
              final Email email = Email(
                  message: decodedString,
                  subject: subject,
                  senderName: _fromInfo[0],
                  senderEmail: senderEmail[0],
                  messageID: messageID,
                  refrences: refrences,
                  inReplyTo: inReplyTo);
              emails.add(email);
            }
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return emails;
  }

  static Future<void> testingEmail(String userId) async {
    final header = await googleUser!.currentUser!.authHeaders;

    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = 'li_mokrane@esi.dz'; // Replace with the sender's email address
    var to =
        "imed.imed1957@gmail.com"; // Replace with the recipient's email address
    var subject = 'test send email';
    var message = "Hi<br/>Html Email";

    var content = '''
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: ${to}
from: ${from}
In-Reply-To: "\"\u003cCA+g6xGoOo+TPiXp598Nh1qDXDF+Di1Ag25J0Uj32KzPdHvfNDQ@mail.gmail.com\u003e\""
Message-ID: "\u003cCAGd2=CnVLUB3N0omom+TRbG6p4AdyXG85GenRzQgXY3jeBRiDg@mail.gmail.com\u003e"
References: "\"\u003cCA+g6xGqfb-G=8YCyNZV6dYg7oFqgyTwYeQTPHuw==HeznZphyQ@mail.gmail.com\u003e \u003cCAGd2=CmGO9vtN9aejSQi2Dr3ddiRfTmwVDLe69u9dp5X18k84g@mail.gmail.com\u003e \u003cCA+g6xGoOo+TPiXp598Nh1qDXDF+Di1Ag25J0Uj32KzPdHvfNDQ@mail.gmail.com\u003e\""

${message}''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url = 'https://www.googleapis.com/gmail/v1/users/' +
        userId +
        '/messages/send';

    final http.Response response = await http.post(
      Uri.parse(url), // Convert the URL string to a Uri object
      headers: header,
      body: body,
    );

    if (response.statusCode != 200) {
      print('error: ' + response.statusCode.toString());
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      print('ok: ' + response.statusCode.toString());
    }
  }

  static signOut() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}
