import 'package:flutter/material.dart';
import 'package:voice_reco_animation/models/voice_rec_notifier.dart';
import 'animated_mic_icon.dart';
import 'slide_to_cancel.dart';

class TimeAndSlide extends StatelessWidget {
  const TimeAndSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecNotifier voiceRecNotifier = VoiceRecNotifier();
    return ValueListenableBuilder(
      valueListenable: voiceRecNotifier.isLongPress,
      builder: (_, bool isLongPress, ch) {
      return AnimatedContainer(
        margin: EdgeInsets.only(
            left: voiceRecNotifier.margin, bottom: voiceRecNotifier.margin),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInToLinear,
        width: voiceRecNotifier.width,
        height: voiceRecNotifier.height,
        child: isLongPress ? ch : const SizedBox(),
      );
      }, 
      child: Row(
        children: const [
          Expanded(flex: 1, child: AnimatedMicIcon()),
          Expanded(
            flex: 1,
            child: VoiceNoteDuration(),
          ),
          SlideToCancel(),
        ],
      ),
    );
  }
}