import 'package:flutter/material.dart';

class ShowBattery extends StatefulWidget {
  final int batteryLevel;

  final Orientation orientation;

  ShowBattery(this.batteryLevel, this.orientation);

  @override
  _ShowBatteryState createState() => _ShowBatteryState();
}

class _ShowBatteryState extends State<ShowBattery> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      width: widget.orientation == Orientation.landscape ? 280 : 150,
      height: widget.orientation == Orientation.landscape ? 150 : 280,
      child: Stack(
        alignment: widget.orientation == Orientation.landscape
            ? Alignment.centerLeft
            : Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.decelerate,
            width: widget.orientation == Orientation.landscape
                ? widget.batteryLevel * 2.7
                : null,
            height: widget.orientation == Orientation.landscape
                ? null
                : widget.batteryLevel * 2.7,
            decoration: BoxDecoration(
                color: widget.batteryLevel > 15 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
    );
  }
}
