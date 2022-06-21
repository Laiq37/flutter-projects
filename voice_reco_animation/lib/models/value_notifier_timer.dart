

import 'package:flutter/widgets.dart';

class TimerNotifier{

 static TimerNotifier? _instance = TimerNotifier._internal();

  factory TimerNotifier() {
    return _instance ??= TimerNotifier._internal();
  }

  TimerNotifier._internal();

  ValueNotifier<String> time = ValueNotifier("00:00");

  void setDuration(String duration){
    time.value = duration;
  }

  void resetDuration(){
    time.value = "00:00";
  }

  void dispose(){
    time.dispose();
    _instance = null;
  }
}