import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyo/controllers/chat_controller.dart';
import 'package:kyo/controllers/email_genearator_controller.dart';
import 'package:kyo/recorder.dart';
import 'package:kyo/emails_request.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:kyo/screens/Auth page/Auth.dart';
import 'package:kyo/screens/Chat page/home_page.dart';
import 'package:sizer/sizer.dart' as sizer;

TextEditingController controller = TextEditingController();
String generatedText = '';
final recorder = Recorder();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmailGenerator()),
        ChangeNotifierProvider(create: (context) => ChatController())
      ],
      child: sizer.Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  if (snapshot.data == null) {
                    return AuthPage();
                  } else {
                    return HomePage();
                  }
                }
              },
            ));
      }),
    );
  }
}
