import 'package:flutter/material.dart';
import 'package:voice_reco_animation/voice_rec_provider.dart';
import 'animated_mic_icon.dart';
import 'slide_to_cancel.dart';

class TimeAndSlide extends StatelessWidget {
  const TimeAndSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit TimeAndSlide');
    // print('timeslider rebuilt');
    // print(time);
    return ValueListenableBuilder(
      valueListenable: voiceRecProvider.isLongPress,
      builder: (_, bool isLongPress, ch) {
        print("rebult timeAmdSlide builder");
      return AnimatedContainer(
        margin: EdgeInsets.only(
            left: voiceRecProvider.margin, bottom: voiceRecProvider.margin),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInToLinear,
        width: voiceRecProvider.width,
        height: voiceRecProvider.height,
        child: isLongPress ? ch : const SizedBox(),
      );
      }, 
      child: Row(
        children: const [
          // const Expanded(flex: 1, child: AnimatedMicIcon()),
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