import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import './voice_rec_provider.dart';

class DeleteVocRecAnim extends StatefulWidget {
  const DeleteVocRecAnim({Key? key}) : super(key: key);

  @override
  State<DeleteVocRecAnim> createState() => _DeleteVocRecAnimState();
}

class _DeleteVocRecAnimState extends State<DeleteVocRecAnim>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  late AnimationController _animationController;

  final VoiceRecProvider voiceRecProvider = VoiceRecProvider();

  //Mic
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashTranslateDown;

  //Trash Can
  late Animation<double> _trashWithCoverTranslateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashWithCoverTranslateDown;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(milliseconds: 3000),
        () => voiceRecProvider.isCancelled.value = false);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    //Mic

    _micTranslateTop = Tween(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 63.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
    //Trash Can
    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    _trashWithCoverTranslateTop = Tween(begin: 50.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.6),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, 10)
                ..translate(_micTranslateRight.value)
                ..translate(_micTranslateLeft.value)
                ..translate(0.0, _micTranslateTop.value)
                ..translate(0.0, _micTranslateDown.value)
                ..translate(0.0, _micInsideTrashTranslateDown.value),
              child: Transform.rotate(
                angle: _micRotationFirst.value,
                child: Transform.rotate(
                  angle: _micRotationSecond.value,
                  child: child,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.mic,
            color: Color(0xFFef5552),
            size: 30,
          ),
        ),
        AnimatedBuilder(
            animation: _trashWithCoverTranslateTop,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, _trashWithCoverTranslateTop.value)
                  ..translate(0.0, _trashWithCoverTranslateDown.value),
                child: child,
              );
            },
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _trashCoverRotationFirst,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(_trashCoverTranslateLeft.value)
                        ..translate(_trashCoverTranslateRight.value),
                      child: Transform.rotate(
                        angle: _trashCoverRotationSecond.value,
                        child: Transform.rotate(
                          angle: _trashCoverRotationFirst.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: const Image(
                    image: AssetImage('assets/trash_cover.png'),
                    width: 24,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 1.5),
                  child: Image(
                    image: AssetImage('assets/trash_container.png'),
                    width: 30,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}