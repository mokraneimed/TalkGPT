import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/gmail/v1.dart';
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
      final email = await user?.user?.email;
      final messages_ids =
          await gmailApi.users.messages.list(email!, maxResults: 20);
      for (final message in messages_ids.messages!) {
        final msg = await gmailApi.users.messages.get(email, message.id!);
        print('Message ID: ${msg.id}');
        print('Snippet: ${msg.snippet}');
        emails.add(msg.snippet);
      }
      print(emails[0]);
      print(messages_ids.messages!.length);
    } catch (e) {
      print(e.toString());
    }
    return emails;
  }

  static signOut() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}
