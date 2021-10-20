//Packages
import 'package:chap_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Screens
import './screens/chat_screen.dart';

void main() async {
  //how to initialize firebase we see from below link
  //https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          backgroundColor: Colors.pink,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      routes: {
        ChatScreen.routeName: (ctx) => ChatScreen(),
      },
      home: StreamBuilder<User?>(
        //FirebaseAuth.instance.authStateChanges() returns a stream of type user which will hold user token if user is login and has null when user is not login or signup
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return ChatScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
