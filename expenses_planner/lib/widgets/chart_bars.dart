import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  final label;
  final spendingAmount;
  final spendingPercentage;

  ChartBars(this.label, this.spendingAmount, this.spendingPercentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, contraints) {
      //we can use layout builder when we have to set size of widget dynamically, it builder arg takes an
      //anonymous function with two parameters which is already provided by layoutbuilder 1st is context and
      //other is constraints(default height and width also we can set height)
      return Column(
        children: [
          Container(
            height: contraints.maxHeight * 0.12,
            child: FittedBox(
              //fittedbox widget force its child to stay in available space
              child: Text(
                'RS.${spendingAmount.toStringAsFixed(0)}',
              ),
            ),
          ),
          SizedBox(
            height: contraints.maxHeight * 0.06,
          ),
          Container(
            height: contraints.maxHeight * 0.4,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: contraints.maxHeight * 0.06,
          ),
          Container(
            height: contraints.maxHeight * 0.12,
            child: FittedBox(
                child: Text(
              label,
            )),
          ),
        ],
      );
    });
  }
}
