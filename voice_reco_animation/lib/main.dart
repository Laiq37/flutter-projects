import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice_reco_animation/sound_player.dart';
import 'package:voice_reco_animation/sound_recoder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print('rebuit MyApp');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VoiceRecAnim(),
    );
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
      body: const VoiceReco(),
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

  Offset offset = Offset.zero;
  double radius = 20;
  double height = 0;
  double margin = 0;
  double width = 0;
  double longPressStart = 0;
  bool? isDrag;
  bool isLongPress = false;
  Timer? timer;
  int timeInSec = 0;
  String time = '00:00';
  bool isReset = false;
  late bool isDenied;
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
    print('rebuit VoiceReco');
    void reset([bool resettingValue = true]) {
      isReset = resettingValue;
      isLongPress = false;
      width = 0;
      height = 0;
      margin = 0;
      timeInSec = 0;
      time = '00:00';
      timer?.cancel();
      setState(() {
        radius = 20;
        offset = Offset.zero;
      });
    }

    // print('stack built');
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            left: 0,
            // MediaQuery.of(context).size.width * 0.3,
            child: TimeAndSlide(
              time: time,
              isLongPress: isLongPress,
              height: height,
              width: width,
              margin: margin,
            )),
        Positioned(
          right: offset.dx,
          bottom: offset.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: () async{
              // print("longPressIsLongPress");
              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if(isReset ) {
                  timer.cancel();
                  return;}
                timeInSec += 1;
                // print(timeInSec);
                setState(() {
                  time = formatTime(timeInSec);
                });
              });
              await recorder.toggleRecording();
              setState(() {
                isLongPress = true;
                width = MediaQuery.of(context).size.width;
                height = MediaQuery.of(context).size.height * 0.05;
                margin = 2;
                radius = 30;
                offset = const Offset(-10, -10);
              });
              },
            onLongPressStart: (startDetails) {
              longPressStart = startDetails.localPosition.dx;
              // print('startdetails ${startDetails.localPosition.dx}');
            },
            onLongPressMoveUpdate: (details) async{
              isDrag ??= true;
              // print(details.localPosition.dx);
              if(isReset)return;
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
              if (-details.localPosition.dx <  -longPressStart && isDrag!) {
                // print(GestureLongPressEndCallback);
                // print('before little bit drag $isReset');
                getAndPlay();
                reset();
                // print('after little bit drag $isReset');
                return;
              }
              // }


              // if(isReset)return;
              setState(() {
                offset = Offset((-details.offsetFromOrigin.dx), -10 + 0);
              });
            },
            onLongPressEnd: (details) async{
              // print('inPressEnd $isReset');
              
              if (isDrag == true) {
                isDrag = null;
              }
              if (offset == Offset.zero && details.localPosition.dx + 20 < 1) {
                isReset = false;
                return;
              }
              if (isReset) {isReset = false;
              return;
              }
              getAndPlay();
              reset(false);
            },
            child: MicIcon(
              radius: radius,
            ),
          ),
        ),
      ],
    );
  }
}

class TimeAndSlide extends StatelessWidget {
  final String time;
  final bool isLongPress;
  final double width;
  final double height;
  final double margin;
  const TimeAndSlide(
      {required this.time,
      required this.isLongPress,
      required this.width,
      required this.height,
      required this.margin,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rebuit TimeAndSlide');
    // print('timeslider rebuilt');
    // print(time);
    return AnimatedContainer(
      margin: EdgeInsets.only(left: margin, bottom: margin),
      decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInToLinear,
      width: width,
      height: height,
      child: isLongPress
          ? Row(
              children: [
                // const Expanded(flex: 1, child: AnimatedMicIcon()),
                const Expanded(flex: 1, child: AnimatedMicIcon()),
                Expanded(
                  flex: 2,
                  child: VoiceNoteDuration(time: time),
                ),
                const SlideToCancel(),
              ],
            )
          : const SizedBox(),
    );
  }
}

class VoiceNoteDuration extends StatelessWidget {
  final String time;
  const VoiceNoteDuration({required this.time, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rebuit VoiceNoteDuration');
    return Text(
      time,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[100]),
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
          style: TextStyle(color: Colors.grey[100]),
        ),
      ),
    );
  }
}

class AnimatedMicIcon extends StatefulWidget {
  final bool isDeleted;
  const AnimatedMicIcon({this.isDeleted = false, Key? key}) : super(key: key);

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
      ),
    );
  }
}

class MicIcon extends StatelessWidget {
  final double radius;

  const MicIcon({required this.radius, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rebuit MicIcon');
    // print(
    //     '-----------------------------------------------------------------\n\n\n');
    // print('MicIcon');
    // print('icon rebuilt');
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        size: radius,
      ),
    );
  }
}
