import 'package:flutter/material.dart';
import 'package:voice_reco_animation/models/voice_rec_notifier.dart';

class SmallMicIcon extends StatelessWidget {
  // final double radius;

  const SmallMicIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecNotifier voiceRecNotifier = VoiceRecNotifier();
    return CircleAvatar(
      radius: voiceRecNotifier.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        size: voiceRecNotifier.micIconRadius(context),
      ),
    );
  }
}