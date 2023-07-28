import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/gmail/v1.dart' hide Message;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

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
        if (parts == null) {
          if (payload.mimeType == "text/plain") {
            List<int> decodedBytes = base64Url.decode(payload.body!.data!);
            String decodedString = utf8.decode(decodedBytes);
            emails.add(decodedString);
          }
        } else {
          for (final part in parts) {
            final body = part.body;
            final data = body!.data;
            final mimeType = part.mimeType;
            if (mimeType == "text/plain") {
              List<int> decodedBytes = base64Url.decode(data!);
              String decodedString = utf8.decode(decodedBytes);
              emails.add(decodedString);
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
In-Reply-To: "\u003cCA+g6xGoOo+TPiXp598Nh1qDXDF+Di1Ag25J0Uj32KzPdHvfNDQ@mail.gmail.com\u003e"
Message-ID: "\u003cCAGd2=Ckf66VWYv047+zkCCAmYnLq-7CUQun6gQ-PLaZk1i-Hwg@mail.gmail.com\u003e"
References: "\u003cCA+g6xGqfb-G=8YCyNZV6dYg7oFqgyTwYeQTPHuw==HeznZphyQ@mail.gmail.com\u003e \u003cCAGd2=CmGO9vtN9aejSQi2Dr3ddiRfTmwVDLe69u9dp5X18k84g@mail.gmail.com\u003e \u003cCA+g6xGoOo+TPiXp598Nh1qDXDF+Di1Ag25J0Uj32KzPdHvfNDQ@mail.gmail.com\u003e"

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
