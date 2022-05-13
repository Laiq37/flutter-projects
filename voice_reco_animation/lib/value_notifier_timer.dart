import 'package:flutter/widgets.dart';

class TimerProvider{

 static final TimerProvider _instance = TimerProvider._internal();

  factory TimerProvider() {
    return _instance;
  }

  TimerProvider._internal();

  ValueNotifier<String> time = ValueNotifier("00:00");

  void setDuration(String duration){
    time.value = duration;
  }

  void resetDuration(){
    time.value = "00:00";
  }

  void dispose(){
    time.dispose();
  }
}