import 'package:flutter/material.dart';
import './value_notifier_timer.dart';

class VoiceNoteDuration extends StatelessWidget {
  const VoiceNoteDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = TimerProvider();
    print('rebuit VoiceNoteDuration');
    return ValueListenableBuilder(
      valueListenable: timerProvider.time,
      builder: (_, String time, __) => Text(
        time,
        // '00:00',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[100], fontSize: 15),
      ),
    );
  }
}