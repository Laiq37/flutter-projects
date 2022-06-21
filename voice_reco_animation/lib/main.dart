import 'package:flutter/material.dart';
import 'package:voice_reco_animation/models/mic_permission.dart';
import 'package:voice_reco_animation/widgets/voice_rec_anim.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  MicPermission().setStatus();
  Future.delayed(const Duration(milliseconds: 200), (() => runApp(const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const VoiceRecAnim());
  }
}

