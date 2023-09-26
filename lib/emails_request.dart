import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyo/screens/models/email.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/people/v1.dart';

class GoogleService {
  static List emails = [];
  static GoogleSignIn? googleUser;
  static UserCredential? user;
  static String? lastToken;
  static bool firstFetch = true;
  static bool isFetching = false;
  static bool signedIn = false;
  static String? photoURL;
  static String? username;

  static int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(8); // Generates a random number between 0 and 7
  }

  static String removeNewlinesBetweenLength(String text) {
    List<String> lines = text.split('\n');
    String finalString = "";

    for (String line in lines) {
      print(line);
      finalString += line.trim();
      if (!(line.length >= 71 && line.length <= 78)) {
        finalString += '\n';
      } else {
        finalString += " ";
      }
    }

    return finalString;
  }

  static signInSilentlyWithGoogle() async {
    try {
      googleUser = GoogleSignIn(
        scopes: [
          GmailApi.gmailReadonlyScope,
          GmailApi.gmailSendScope,
          PeopleServiceApi.directoryReadonlyScope
        ],
      );

      GoogleSignInAccount? account = await googleUser!.signInSilently();
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
      photoURL = FirebaseAuth.instance.currentUser!.photoURL;
      username = FirebaseAuth.instance.currentUser!.displayName;
      final authClient = await googleUser!.authenticatedClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("type", authClient!.credentials.accessToken.type);
      await prefs.setString("data", authClient.credentials.accessToken.data);
      await prefs.setString(
          "expiry", authClient.credentials.accessToken.expiry.toString());
      if (authClient.credentials.refreshToken != null) {
        await prefs.setString(
            "refreshToken", authClient.credentials.refreshToken!);
      } else {
        await prefs.setString("refreshToken", "");
      }
      await prefs.setStringList("scopes", authClient.credentials.scopes);
      final header = await googleUser!.currentUser!.authHeaders;
      await prefs.setString("auth", header['Authorization']!);
      await prefs.setString("X-Goog-AuthUser", header['X-Goog-AuthUser']!);
      return true;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  static signInWithGoogle() async {
    try {
      googleUser = GoogleSignIn(
        scopes: [
          GmailApi.gmailReadonlyScope,
          GmailApi.gmailSendScope,
          PeopleServiceApi.directoryReadonlyScope
        ],
      );

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
      photoURL = FirebaseAuth.instance.currentUser!.photoURL;
      username = FirebaseAuth.instance.currentUser!.displayName;
      final authClient = await googleUser!.authenticatedClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("type", authClient!.credentials.accessToken.type);
      await prefs.setString("data", authClient.credentials.accessToken.data);
      await prefs.setString(
          "expiry", authClient.credentials.accessToken.expiry.toString());
      if (authClient.credentials.refreshToken != null) {
        await prefs.setString(
            "refreshToken", authClient.credentials.refreshToken!);
      } else {
        await prefs.setString("refreshToken", "");
      }
      await prefs.setStringList("scopes", authClient.credentials.scopes);
      final header = await googleUser!.currentUser!.authHeaders;
      await prefs.setString("auth", header['Authorization']!);
      await prefs.setString("X-Goog-AuthUser", header['X-Goog-AuthUser']!);
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  static Future<void> printFutureMap() async {
    Future<Map<String, String>> futureMap = googleUser!.currentUser!
        .authHeaders; // Replace fetchMap with your actual asynchronous operation

    try {
      Map<String, String> resultMap = await futureMap;
      print(resultMap);
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  static getEmails() async {
    List _emails = [];
    if (!isFetching) {
      isFetching = true;
      try {
        if (firstFetch) {
          emails = [];
          firstFetch = false;
        }
        int maxResults = 10;
        int counter = 0;

        ListMessagesResponse? messages_ids;

        SharedPreferences prefs = await SharedPreferences.getInstance();

        AccessToken newAccessToken = AccessToken(
            prefs.getString("type")!,
            prefs.getString("data")!,
            DateTime.parse(prefs.getString("expiry")!));

        AccessCredentials newAccessCd = AccessCredentials(newAccessToken,
            prefs.getString("refreshToken"), prefs.getStringList("scopes")!);

        AuthClient? newClient = authenticatedClient(http.Client(), newAccessCd);

        final gmailApi = GmailApi(newClient);
        final peopleApi = PeopleServiceApi(newClient);
        final email = FirebaseAuth.instance.currentUser?.email;

        while (counter < 10) {
          final messages_ids = await gmailApi.users.messages.list(email!,
              maxResults: maxResults, q: "in:inbox", pageToken: lastToken);

          for (final message in messages_ids.messages!) {
            final msg = await gmailApi.users.messages.get(email, message.id!);
            final payload = msg.payload;
            final parts = payload!.parts;

            String? threadId = msg.threadId;

            String? subject = payload.headers!
                .firstWhereOrNull(
                  (header) => header.name == "Subject",
                )!
                .value;
            //print(subject);
            String? fromInfo = payload.headers!
                .firstWhereOrNull((header) => header.name == "From")!
                .value;
            //print(fromInfo);
            List<String> _fromInfo = fromInfo!.split("\u003c");
            //print(_fromInfo[0]);
            List<String> senderEmail = _fromInfo[1].split("\u003e");
            SearchDirectoryPeopleResponse? peopleResponse;
            try {
              peopleResponse = await peopleApi.people.searchDirectoryPeople(
                  sources: ["DIRECTORY_SOURCE_TYPE_DOMAIN_PROFILE"],
                  readMask: "photos",
                  query: senderEmail[0]);
            } catch (e) {
              print(e.toString());
            }
            String? photoUrl;
            if (peopleResponse!.toJson().containsKey("people")) {
              final people = peopleResponse.people;
              if (people![0].toJson().containsKey("photos")) {
                photoUrl = people[0].photos![0].url;
              } else {
                photoUrl = null;
              }
            } else {
              photoUrl = null;
            }

            int profileColor = generateRandomNumber();

            //print(senderEmail[0]);
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

            //print(inReplyTo);
            try {
              messageID = payload.headers!
                  .firstWhere((header) => header.name == "Message-ID")
                  .value;
            } catch (e) {
              messageID = null;
            }
            //print(messageID);
            try {
              refrences = payload.headers!
                  .firstWhere((header) => header.name == "Refrences")
                  .value;
            } catch (e) {
              refrences = null;
            }

            //print(refrences);
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
                  inReplyTo: inReplyTo,
                  threadId: threadId,
                  photoUrl: photoUrl,
                  profileColor: profileColor,
                );
                _emails.add(email);
                counter++;
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
                    inReplyTo: inReplyTo,
                    threadId: threadId,
                    photoUrl: photoUrl,
                    profileColor: profileColor,
                  );
                  _emails.add(email);
                  counter++;
                  break;
                } else {
                  final parts_ = part.parts;
                  if (parts_ != null) {
                    for (final part_ in parts_) {
                      final body_ = part_.body;
                      final data_ = body_!.data;
                      final mimeType_ = part_.mimeType;
                      if (mimeType_ == "text/plain") {
                        List<int> decodedBytes_ = base64Url.decode(data_!);
                        String decodedString_ = utf8.decode(decodedBytes_);

                        final Email email = Email(
                          message: decodedString_,
                          subject: subject,
                          senderName: _fromInfo[0],
                          senderEmail: senderEmail[0],
                          messageID: messageID,
                          refrences: refrences,
                          inReplyTo: inReplyTo,
                          threadId: threadId,
                          photoUrl: photoUrl,
                          profileColor: profileColor,
                        );
                        _emails.add(email);
                        counter++;
                        break;
                      }
                    }
                  }
                }
              }
            }
          }
          //print(counter);
          maxResults = maxResults - counter;
          lastToken = messages_ids.nextPageToken;
        }
      } catch (e) {
        print(e.toString());
        return false;
      } finally {
        isFetching = false;
        emails.addAll(_emails);
      }
    }
    return true;
  }

  static Future<bool> testingEmail(Email email, String mailResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> header = {
      "Authorization": prefs.getString("auth")!,
      "X-Goog-AuthUser": prefs.getString("X-Goog-AuthUser")!
    };
    print("hna");
    header['Accept'] = 'application/json';
    header['Content-type'] = 'application/json';

    var from = FirebaseAuth.instance.currentUser!.email;
    var name = FirebaseAuth.instance.currentUser!
        .displayName; // Replace with the sender's email address
    var to = email.senderEmail;
    var toName = FirebaseAuth.instance.currentUser!
        .displayName; // Replace with the recipient's email address
    var subject = email.subject;
    var message = mailResponse;

    var threadId = email.threadId;

    var refrences = (email.refrences != null) ? email.refrences : '';
    var inReplyTo =
        (email.inReplyTo != null) ? email.inReplyTo : email.messageID;
    var messageID = email.messageID;
    print(inReplyTo);
    print(messageID);
    print(refrences);
    var content = '''
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Delivered-To: $to
To: $toName \u003c$to\u003e
From: $name \u003c$from\u003e
Subject: Re: $subject
In-Reply-To: $inReplyTo
References: $refrences $inReplyTo


${message}''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({"threadId": threadId, 'raw': base64});

    String url =
        'https://www.googleapis.com/gmail/v1/users/' + from! + '/messages/send';

    try {
      final http.Response response = await http.post(
        Uri.parse(url), // Convert the URL string to a Uri object
        headers: header,
        body: body,
      );

      if (response.statusCode != 200) {
        print('error: ' + response.statusCode.toString());
        return false;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        print('ok: ' + response.statusCode.toString());
        return true;
      }
    } catch (e) {
      print("error while sending. Check connection");
      return false;
    }
  }

  static signOut() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}
