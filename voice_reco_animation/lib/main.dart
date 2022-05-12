// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice_reco_animation/sound_player.dart';
import 'package:voice_reco_animation/sound_recoder.dart';
// import 'package:provider/provider.dart';
import 'package:voice_reco_animation/value_notifier_timer.dart';
import 'package:voice_reco_animation/voice_rec_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('rebuit MyApp');
    // return MultiProvider(
    //   create: (context) => VoiceRecProvider(),
    //   child: MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const VoiceRecAnim(),
    //   ),
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const VoiceRecAnim());
    // StreamProvider(create: (_) => TimerProvider()),
// ;
  }
}

class VoiceRecAnim extends StatelessWidget {
  const VoiceRecAnim({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('rebuit VoiceRecAnim');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Rec Animation'),
      ),
      body:  const VoiceReco(),
    );
  }
}

class VoiceReco extends StatefulWidget {
  const VoiceReco({Key? key}) : super(key: key);

  @override
  State<VoiceReco> createState() => _VoiceRecoState();
}

class _VoiceRecoState extends State<VoiceReco> {
  String formatTime(int seconds) {
    int m, s;
    // return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
    m = (seconds) ~/ 60;

    s = seconds - (m * 60);

    return "${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }
  getAndPlay()async{
    final String? path = await recorder.toggleRecording();
    path != null ? await player.togglePlaying(whenFinished: ()=>print("audio has been played"), path: path):print('Nothing to play');
  }

  // Offset offset = Offset.zero;
  // double radius = 20;
  // double height = 0;
  // double margin = 0;
  // double width = 0;
  double longPressStart = 0;
  // bool? isDrag;
  // bool isLongPress = false;
  Timer? timer;
  // int timeInSec = 0;
  String? time;
  // bool isReset = false;
  SoundRecorder recorder = SoundRecorder();
  SoundPlayer player = SoundPlayer();

// void getMicStatus() async{
//   print("init");
//     isDenied = await Permission.microphone.isDenied;
//     if(isDenied){
//       final status = await Permission.microphone.request();
//       if(status != PermissionStatus.granted)return;
//         isDenied = false;
//     }
//         await recorder.openRecorder();
//         recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }
initRecorderPlayer()async{
  await recorder.init();
  await player.init();
}

@override
  void initState() {
    super.initState();
    initRecorderPlayer();
  }

  @override
  void dispose() {
    timer?.cancel();
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = TimerProvider();
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();


    print('rebuit VoiceReco');
    void reset([bool resettingValue = true]) {
      voiceRecProvider.reset(resettingValue);
                  timerProvider.resetDuration();
                  timer?.cancel();
                  // timer = null;
                  print("inReset");
                  // setState(() {
                    
                  // });
    }

    // print('stack built');
    return Stack(
      children: [
        // ignore: prefer_const_constructors
        const Positioned(
            bottom: 0,
            left: 0,
            // MediaQuery.of(context).size.width * 0.3,
            child:  TimeAndSlide(
              // time: time,
              // isLongPress: isLongPress,
              // height: height,
              // width: width,
              // margin: margin,
            )),
        // Consumer<VoiceRecProvider>
        ValueListenableBuilder<Offset>(
          valueListenable: voiceRecProvider.offset,
          builder: ((contet,Offset offset, child) {
             print("dx ${offset.dx}  dy ${offset.dy}");
          return Positioned(
            right: offset.dx,
            bottom: offset.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () async{
                // print("longPressIsLongPress");
                timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
                  if(voiceRecProvider.isReset ) {
                    timer.cancel();
                    return;}
                  voiceRecProvider.timeInSec += 1;
                  // print(timeInSec);
                  // setState(() {
                  // setState(() {
                    print("time after each sec ${voiceRecProvider.timeInSec}");
                    time = formatTime(voiceRecProvider.timeInSec);
                    timerProvider.setDuration(time!);
                  // });
                });
                await recorder.toggleRecording();
                voiceRecProvider.onLongPressValue(context);
                setState(() {
                });
                },
              onLongPressStart: (startDetails) {
                longPressStart = startDetails.localPosition.dx;
                // print('startdetails ${startDetails.localPosition.dx}');
              },
              onLongPressMoveUpdate: (details) async{
                voiceRecProvider.isDrag ??= true;
                // print(details.localPosition.dx);
                if(voiceRecProvider.isReset)return;
                if (MediaQuery.of(context).size.width * 0.30 <=
                    -details.offsetFromOrigin.dx) {
                      // print('before slid to cancel $isReset');
                      await recorder.toggleRecording();
                  reset();
                  // print('after slid to cancel $isReset');
                  // kLongPressTimeout.inMilliseconds;
                  return;
                }
                // print(
                // 'if ${-details.localPosition.dx} < 0 && ${details.offsetFromOrigin.dx} return');
                // if (-details.localPosition.dx < 0) {
                if (-details.localPosition.dx <  -longPressStart && voiceRecProvider.isDrag!) {
                  // print(GestureLongPressEndCallback);
                  // print('before little bit drag $isReset');
                  getAndPlay();
                  reset();
                  // print('after little bit drag $isReset');
                  return;
                }
                // }
        
        
                // if(isReset)return;
                voiceRecProvider.changeIconOffset(details, context);
              },
              onLongPressEnd: (details) async{
                // print('inPressEnd $isReset');
                
                if (voiceRecProvider.isDrag == true) {
                  voiceRecProvider.isDrag = null;
                }
                if (offset == Offset.zero && details.localPosition.dx + 20 < 1) {
                  voiceRecProvider.isReset = false;
                  return;
                }
                if (voiceRecProvider.isReset) {voiceRecProvider.isReset = false;
                return;
                }
                print("long press released");
                getAndPlay();
                reset(false);
              },
              child: 
            !voiceRecProvider.isLongPress.value ? const SmallMicIcon() : const BigMicIcon()
              )
            );
  }),
    )],
    );
  }
}

class TimeAndSlide extends StatelessWidget {
  const TimeAndSlide(
      {
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit TimeAndSlide');
    // print('timeslider rebuilt');
    // print(time);
    return ValueListenableBuilder(valueListenable: voiceRecProvider.isLongPress, builder: (_,bool isLongPress, ch)=>
      AnimatedContainer(
        margin: EdgeInsets.only(left: voiceRecProvider.margin, bottom: voiceRecProvider.margin),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInToLinear,
        width: voiceRecProvider.width,
        height: voiceRecProvider.height,
        child:  isLongPress ? ch
            : const SizedBox(),
      ),
      child: Row(
                children: const [
                  // const Expanded(flex: 1, child: AnimatedMicIcon()),
                    Expanded(flex:1 ,child: AnimatedMicIcon()),
                   Expanded(
                    flex:1,
                    child: VoiceNoteDuration(),
                  ),
                   SlideToCancel(),
                ],
              ),
    );
  }
}

class VoiceNoteDuration extends StatelessWidget {
  
  const VoiceNoteDuration({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider = TimerProvider();
    print('rebuit VoiceNoteDuration');
    return ValueListenableBuilder(valueListenable: timerProvider.time, builder: (_,String time,__)=> Text(
        time,
        // '00:00',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[100],fontSize: 15),
      ),
    );
  }
}

class SlideToCancel extends StatelessWidget {
  const SlideToCancel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rebuit SlideToCancel');
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

class AnimatedMicIcon extends StatefulWidget {
  const AnimatedMicIcon({Key? key}) : super(key: key);

  @override
  State<AnimatedMicIcon> createState() => _AnimatedMicIconState();
}

class _AnimatedMicIconState extends State<AnimatedMicIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // print("initstate");
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds:700));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    // print('in dispose');
  }

  @override
  Widget build(BuildContext context) {
    print('rebuit AnimatedMicIcon');
    return FadeTransition(
      opacity: _opacityAnimation,
      child: const Icon(
        Icons.mic,
        color: Colors.red,
        size: 16
      ),
    );
  }
}

class SmallMicIcon extends StatelessWidget {
  // final double radius;

  const SmallMicIcon({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit MicIcon');
    print(voiceRecProvider.micIconRadius(context));
    // print(
    //     '-----------------------------------------------------------------\n\n\n');
    // print('MicIcon');
    // print('icon rebuilt');
    return 
    CircleAvatar(
      radius: voiceRecProvider.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        size: voiceRecProvider.micIconRadius(context),
      ),
    );
  }
}

class BigMicIcon extends StatelessWidget {
  // final double radius;

  const BigMicIcon({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecProvider voiceRecProvider = VoiceRecProvider();
    print('rebuit MicIcon');
    print(MediaQuery.of(context).size);
    // print(voiceRecProvider.micIconRadius(context)*voiceRecProvider.radius);
    // print(
    //     '-----------------------------------------------------------------\n\n\n');
    // print('MicIcon');
    // print('icon rebuilt');
    return CircleAvatar(
      radius: voiceRecProvider.micIconRadius(context),
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        color: Colors.white,
        size:   voiceRecProvider.micIconRadius(context),
      ),
    );
  }
}
