
import 'dart:math';

import 'package:flutter/cupertino.dart';
class VoiceRecProvider{


  static final VoiceRecProvider _instance = VoiceRecProvider._internal();

  factory VoiceRecProvider() {
    return _instance;
  }

  VoiceRecProvider._internal();

  ValueNotifier<Offset> offset = ValueNotifier(Offset.zero);
  double radius = 0.07;
  double height = 0;
  double margin = 0;
  double width = 0;
  double longPressStart = 0;
  bool? isDrag;
  ValueNotifier<bool> isLongPress = ValueNotifier<bool>(false);
  int timeInSec = 0;
  bool isReset = false;

  void reset([bool resettingValue = true]) {
      isReset = resettingValue;
      isLongPress.value = false;
      width = 0;
      height = 0;
      margin = 0;
      timeInSec = 0;
      radius =  0.07;
        offset.value = Offset.zero;
        // notifyListeners();
    }

  void onLongPressValue(BuildContext context){
    isLongPress.value = true;
                width = MediaQuery.of(context).size.width;
                height = MediaQuery.of(context).size.height * 0.056;
                margin = 2;
                radius =  0.1;
                offset.value =Offset(-micIconRadius(context)/4, -micIconRadius(context)/3);
                // notifyListeners();
  }

  double micIconRadius(BuildContext context){
    final double l = MediaQuery.of(context).size.height * radius;
    final double w = MediaQuery.of(context).size.width * radius;
    return (sqrt((l*l)+(w*w)))/2;
  }

  void changeIconOffset(LongPressMoveUpdateDetails details, BuildContext context){
    offset.value = Offset((-details.offsetFromOrigin.dx), -micIconRadius(context)/3 + 0);
    // notifyListeners();
  }

}