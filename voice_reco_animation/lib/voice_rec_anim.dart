import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './sound_recoder.dart';
import './sound_player.dart';
import 'small_mic.dart';
import 'big_mic_icon.dart';
import './delete_voc_rec_anim.dart';
import './time_and_slide.dart';
import './value_notifier_timer.dart';
import './voice_rec_provider.dart';

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

    m = (seconds) ~/ 60;

    s = seconds - (m * 60);

    return "${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  getAndPlay() async {
    final String? path = await recorder.toggleRecording();
    path != null
        ? await player.togglePlaying(
            whenFinished: () => print("audio has been played"), path: path)
        : print('Nothing to play');
  }

  Future<bool> getPermissionStatus() async {
    final bool status = await Permission.microphone.status.isGranted;
    return status;
  }

  Future requestPermission() async {
    await Permission.microphone.request();
  }

  double longPressStart = 0;

  Timer? timer;
  String? time;
  SoundRecorder recorder = SoundRecorder();
  SoundPlayer player = SoundPlayer();
  late TimerProvider timerProvider;
  late VoiceRecProvider voiceRecProvider;
  bool isGranted = false;

  initRecorderPlayer() async {
    await recorder.init();
    await player.init();
    final bool status  = await getPermissionStatus();
     if(status){
       isGranted = status;
                            setState(() {});
                            }
  }

  @override
  void initState() {
    super.initState();
    initRecorderPlayer();
    timerProvider = TimerProvider();
    voiceRecProvider = VoiceRecProvider();
  }

  @override
  void dispose() {
    timer?.cancel();
    recorder.dispose();
    player.dispose();
    timerProvider.dispose();
    voiceRecProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuit VoiceReco');
    void reset([bool resettingValue = true]) {
      voiceRecProvider.reset(resettingValue);
      timerProvider.resetDuration();
      timer?.cancel();
    }

    // print('stack built');
    return Stack(
      children: [
        const Positioned(
            bottom: 0,
            left: 0,
            child: TimeAndSlide(
                )),
        ValueListenableBuilder<Offset>(
          valueListenable: voiceRecProvider.offset,
          builder: ((context, Offset offset, child) {
            print("rebuilt voiceRecoBuilder");
            return Positioned(
                right: offset.dx,
                bottom: offset.dy,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: !isGranted
                        ? () async {
                          print('inPermission');
                            await requestPermission();
                            final status = await getPermissionStatus();
                            if(status){
                              isGranted = status;
                            setState(() {});
                            } 
                          }
                        : () async {
                            // print("longPressIsLongPress");
                            timer = Timer.periodic(
                                const Duration(milliseconds: 1000), (timer) {
                              if (voiceRecProvider.isReset) {
                                timer.cancel();
                                return;
                              }
                              voiceRecProvider.timeInSec += 1;
                              print(
                                  "time after each sec ${voiceRecProvider.timeInSec}");
                              time = formatTime(voiceRecProvider.timeInSec);
                              timerProvider.setDuration(time!);
                              // });
                            });
                            await recorder.toggleRecording();
                            print('long Press true');
                            voiceRecProvider.onLongPressValue(context);
                          },
                    onLongPressStart: (startDetails) {
                      longPressStart = startDetails.globalPosition.dx;
                    },
                    onLongPressMoveUpdate: (details) async {
                      if (!isGranted) return;
                      voiceRecProvider.isDrag ??= true;
                      // print(details.localPosition.dx);
                      if (voiceRecProvider.isReset) return;
                      if (MediaQuery.of(context).size.width * 0.30 <=
                          -details.offsetFromOrigin.dx) {
                        // print('before slid to cancel $isReset');
                        await recorder.toggleRecording();
                        voiceRecProvider.isCancelled.value = true;
                        reset();

                        return;
                      }

                      // if (-details.offsetFromOrigin.dx < -longPressStart &&
                      //     voiceRecProvider.isDrag!) {
                      //       print(-details.offsetFromOrigin.dx);
                      //       print(-longPressStart);
                      //   // getAndPlay();
                      //   // reset();
                      //   return;
                      // }
                      // }

                      // if(isReset)return;
                      voiceRecProvider.changeIconOffset(details, context);
                    },
                    onLongPressEnd: (details) async {
                      print('inPressEnd yes');
                      if (!isGranted) return;

                      if (voiceRecProvider.isDrag == true) {
                        voiceRecProvider.isDrag = null;
                      }
                      if (offset == Offset.zero &&
                          details.localPosition.dx + 20 < 1) {
                        voiceRecProvider.isReset = false;
                        return;
                      }
                      if (voiceRecProvider.isReset) {
                        voiceRecProvider.isReset = false;
                        return;
                      }
                      print("long press released");
                      getAndPlay();
                      reset(false);
                    },
                    child: !voiceRecProvider.isLongPress.value
                        ? const SmallMicIcon()
                        : const BigMicIcon()));
          }),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: voiceRecProvider.isCancelled,
          builder: (_, bool isCancelled, __) {
            print('rebuilt voiceReco isCancelled animation builder');
          return Positioned(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: 2,
              child: ValueListenableBuilder<bool>(
                  valueListenable: voiceRecProvider.isCancelled,
                  builder: (_, bool isCancelled, __) => isCancelled
                      ? const DeleteVocRecAnim()
                      : const SizedBox()));
          }
        )
      ],
    );
  }
}