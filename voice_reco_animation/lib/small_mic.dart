import 'package:flutter/material.dart';
import './voice_rec_provider.dart';

class SmallMicIcon extends StatelessWidget {
  // final double radius;

  const SmallMicIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit MicIcon');
    // print(voiceRecProvider.micIconRadius(context));
    // print('MicIcon');
    // print('icon rebuilt');
    return CircleAvatar(
      radius: voiceRecProvider.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        size: voiceRecProvider.micIconRadius(context),
      ),
    );
  }
}