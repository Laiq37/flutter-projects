import 'package:flutter/material.dart';
import './voice_rec_provider.dart';

class BigMicIcon extends StatelessWidget {
  // final double radius;

  const BigMicIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit MicIcon');
    // print(MediaQuery.of(context).size);

    // print('MicIcon');
    // print('icon rebuilt');
    return CircleAvatar(
      radius: voiceRecProvider.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        color: Colors.white,
        size: voiceRecProvider.micIconRadius(context),
      ),
    );
  }
}