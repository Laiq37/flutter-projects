import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice_reco_animation/models/value_notifier_timer.dart';

class VoiceNoteDuration extends StatelessWidget {
  const VoiceNoteDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimerNotifier timerNotifier = TimerNotifier();
    return ValueListenableBuilder(
      valueListenable: timerNotifier.time,
      builder: (_, String time, __) => Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[100], fontSize: 15),
      ),
    );
  }
}

class SlideToCancel extends StatelessWidget {
  const SlideToCancel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('rebuit SlideToCancel');
    return Expanded(
      flex: 3,
      child: Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        highlightColor: Colors.grey[100]!,
        baseColor: Colors.grey[700]!,
        child: Text(
          '<    Slide to cancel',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[100], fontSize: 19),
        ),
      ),
    );
  }
}