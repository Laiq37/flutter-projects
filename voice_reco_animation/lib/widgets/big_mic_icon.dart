import 'package:flutter/material.dart';
import 'package:voice_reco_animation/models/voice_rec_notifier.dart';

class BigMicIcon extends StatelessWidget {

  const BigMicIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecNotifier voiceRecNotifier = VoiceRecNotifier();
    return CircleAvatar(
      radius: voiceRecNotifier.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        color: Colors.white,
        size: voiceRecNotifier.micIconRadius(context),
      ),
    );
  }
}