import 'package:expenses_planner/widgets/chart_bars.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Charts extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Charts(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(
          days: index,
        ),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalspending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    }); //fold allows us to change a list to another type with a certain logic we defined to fold
    // first arg is initial value and second argument takes a function and that function have two arg one is initial value(first arg of fold ) and second is item of list
  }

  @override
  Widget build(BuildContext context) {
    //print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        //Padding widget is used to add padding
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              //flexible takes a fit arg, flex arg by default is 1 we can change it by setting flex value
              // how flexible widget takes space according to it flex value? it sum the value of flex of those widget which are wrap in flexible widget and then give space accordingly
              // e.g: w1-->widget 1, w2--> widget 2 wrap in flexible widget, w3--> widget 3 also wrap in flexible widget and flex value is 2
              // w1 take as much space its child require but w2 and w3 flex will be added and then they get their space accordingly
              //Expanded can be a replacement for Flexible widget if we want flexFit tight, it dont take fit arg but can take flex arg
              fit: FlexFit.tight,
              child: ChartBars(
                  data['day'].toString(),
                  (data['amount'] as double),
                  totalspending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalspending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
