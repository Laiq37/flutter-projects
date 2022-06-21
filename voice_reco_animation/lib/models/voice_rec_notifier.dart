
import 'dart:math';

import 'package:flutter/cupertino.dart';
class VoiceRecNotifier{


  static VoiceRecNotifier? _instance = VoiceRecNotifier._internal();

  factory VoiceRecNotifier() {
   return _instance ??= VoiceRecNotifier._internal();
  //  return _instance!;
  }

  VoiceRecNotifier._internal();

  ValueNotifier<Offset> offset = ValueNotifier(Offset.zero);
  double radius = 0.06;
  double height = 0;
  double margin = 0;
  double width = 0;
  double longPressStart = 0;
  bool? isDrag;
  ValueNotifier<bool> isLongPress = ValueNotifier<bool>(false);
  int timeInSec = 0;
  bool isReset = false;
  ValueNotifier<bool> isCancelled = ValueNotifier(false);

  void reset([bool resettingValue = true]) {
      isReset = resettingValue;
      isLongPress.value = false;
      width = 0;
      height = 0;
      margin = 0;
      timeInSec = 0;
      radius =  0.06;
        offset.value = Offset.zero;
    }

  void onLongPressValue(BuildContext context){
    isLongPress.value = true;
    isCancelled.value = false;
                width = MediaQuery.of(context).size.width;
                height = MediaQuery.of(context).size.height * 0.045;
                margin = 2;
                radius =  0.08;
                offset.value =Offset(-micIconRadius(context)/5, -micIconRadius(context)/3);
  }

  double micIconRadius(BuildContext context){
    final double l = MediaQuery.of(context).size.height * radius;
    final double w = MediaQuery.of(context).size.width * radius;
    return (sqrt((l*l)+(w*w)))/2;
  }

  void changeIconOffset(LongPressMoveUpdateDetails details, BuildContext context){
    offset.value = Offset((-details.offsetFromOrigin.dx), -micIconRadius(context)/3 + 0);
  }

  void dispose(){
    offset.dispose();
    isLongPress.dispose();
    _instance = null;
  }

}