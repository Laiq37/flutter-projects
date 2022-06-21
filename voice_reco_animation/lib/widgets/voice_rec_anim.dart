import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_reco_animation/models/mic_permission.dart';
import 'package:voice_reco_animation/models/value_notifier_timer.dart';
import 'package:voice_reco_animation/models/voice_rec_notifier.dart';
import './sound_recoder.dart';
import 'small_mic.dart';
import 'big_mic_icon.dart';
import './delete_voc_rec_anim.dart';
import './time_and_slide.dart';

class VoiceRecAnim extends StatelessWidget {
  const VoiceRecAnim({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
  double longPressStart = 0;
  Timer? timer;
  String? time;
  SoundRecorder recorder = SoundRecorder();
  late TimerNotifier timerNotifier;
  late VoiceRecNotifier voiceRecNotifier;
  final ValueNotifier<bool> isGrantedNotifier =
      ValueNotifier(MicPermission().getStatus());

  initRecorderPlayer() async {
    if (!recorder.isInitialized) {
      await recorder.init();
    }
  }
  String formatTime(int seconds) {
    int m, s;

    m = (seconds) ~/ 60;

    s = seconds - (m * 60);

    return "${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  deleteCancelledAudioFile() async {
    final String? path = await recorder.stop();
    recorder.delete(path!);
  }

  Future<bool> getPermissionStatus() async {
    final bool status = await Permission.microphone.status.isGranted;
    return status;
  }

  Future requestPermission() async {
    final PermissionStatus status = await Permission.microphone.request();
    return status == PermissionStatus.granted ? true : false;
  }

  void reset([bool resettingValue = true]) {
    voiceRecNotifier.reset(resettingValue);
    timerNotifier.resetDuration();
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    initRecorderPlayer();
    timerNotifier = TimerNotifier();
    voiceRecNotifier = VoiceRecNotifier();
  }

  @override
  void dispose() {
    timer?.cancel();
    recorder.dispose();
    timerNotifier.dispose();
    voiceRecNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(bottom: 0, left: 0, right: 0, child: TimeAndSlide()),
        ValueListenableBuilder<Offset>(
          valueListenable: voiceRecNotifier.offset,
          builder: ((context, Offset offset, child) {
            return Positioned(
                right: offset.dx,
                bottom: offset.dy,
                child: ValueListenableBuilder(
                    valueListenable: isGrantedNotifier,
                    builder: (context, bool isGranted, _) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPress: !isGranted
                            ? () async {
                                final status = await requestPermission();
                                if (status) {
                                  isGrantedNotifier.value = status;
                                  MicPermission().setStatus(status);
                                }
                              }
                            : () async {
                                if (voiceRecNotifier.isReset) {
                                  voiceRecNotifier.isReset = false;
                                }
                                timer = Timer.periodic(
                                    const Duration(milliseconds: 1000),
                                    (timer) async {
                                  voiceRecNotifier.timeInSec += 1;
                                  time = formatTime(voiceRecNotifier.timeInSec);
                                  timerNotifier.setDuration(time!);
                                });
                                await recorder.record();
                                voiceRecNotifier.onLongPressValue(context);
                              },
                        onLongPressStart: (startDetails) {
                          longPressStart = startDetails.globalPosition.dx;
                        },
                        onLongPressMoveUpdate: (details) async {
                          if (!isGranted) return;
                          if (voiceRecNotifier.isReset) return;
                          if (details.globalPosition.dx > longPressStart)return;
                          if (MediaQuery.of(context).size.width * 0.30 <=
                              -details.offsetFromOrigin.dx) {
                            deleteCancelledAudioFile();
                            voiceRecNotifier.isCancelled.value = true;
                            reset();
                            return;
                          }
                          voiceRecNotifier.changeIconOffset(details, context);
                        },
                        onLongPressEnd: (details) async {
                          if (voiceRecNotifier.isReset) return;
                          await recorder.stop();
                          reset();
                        },
                        child: !voiceRecNotifier.isLongPress.value
                            ? const SmallMicIcon()
                            : const BigMicIcon())));
          }),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.05,
          bottom: 2,
          child: ValueListenableBuilder<bool>(
            valueListenable: voiceRecNotifier.isCancelled,
            builder: (_, bool isCancelled, ch) =>
                isCancelled ? ch! : const SizedBox(),
            child: const DeleteVocRecAnim(),
          ),
        )
      ],
    );
  }
}
