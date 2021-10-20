import 'dart:async';

import 'package:flutter/material.dart';

import 'package:battery/battery.dart';
import 'package:flutter/rendering.dart';
import '../widgets/battery.dart';

class BatterLife extends StatefulWidget {
  @override
  _BatterLifeState createState() => _BatterLifeState();
}

class _BatterLifeState extends State<BatterLife> {
  final Battery _battery = Battery();

  int? _batteryLevel;

  Timer? _timer;

  Future<void> getBatteryLevel() async {
    if (_batteryLevel == 0 && _timer != null) {
      _timer!.cancel();
    }

    int bbl = await _battery.batteryLevel;
    print(_batteryLevel);
    if (_batteryLevel == null) {
      {
        setState(() {
          _batteryLevel = bbl;
        });
      }
      _batteryLevel = bbl;
    }
    if (_batteryLevel != bbl) {
      setState(() {
        _batteryLevel = bbl;
      });
    }
  }

  @override
  void initState() {
    final Battery _battery = Battery();

    getBatteryLevel();

    // TODO: implement initState
    _timer = Timer.periodic(Duration(seconds: 45), (_) {
      getBatteryLevel();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.deepPurple),
        height: double.infinity,
        width: double.infinity,
        child: OrientationBuilder(
            builder: (ctx, orientation) => AnimatedSwitcher(
                  switchInCurve: Curves.easeInQuart,
                  // switchOutCurve: Curves.bounceOut,
                  duration: Duration(milliseconds: 500),
                  child: orientation == Orientation.portrait
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _batteryLevel == null
                                ? CircularProgressIndicator()
                                : ShowBattery(_batteryLevel!, orientation),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Status',
                              style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Level: $_batteryLevel%',
                              style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _batteryLevel == null
                                ? CircularProgressIndicator()
                                : ShowBattery(_batteryLevel!, orientation),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Status',
                                  style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Level: $_batteryLevel%',
                                  style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                )),
      ),
    );
  }
}
