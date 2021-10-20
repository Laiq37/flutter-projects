import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<dynamic> values = [
    '%',
    'sqr',
    'CE',
    Icons.cancel_presentation,
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '/',
    '1',
    '2',
    '3',
    '-',
    '.',
    '0',
    '=',
    '+'
  ];

  String text = '';

  String prevText = '';

  String operation = '';

  bool equalsTo = false;

  void _showText(String val) {
    setState(() {
      text = text + val;
      print(text);
    });
  }

  void _clear() {
    if (text != '') {
      setState(() {
        text = text.replaceRange(text.length - 1, text.length, '');
      });
    }
  }

  void _delete() {
    setState(() {
      text = '';
      prevText = '';
      operation = '';
    });
  }

  _sqr(String val) {
    if (text != '') {
      prevText = (double.parse(text) * double.parse(text)).toString();
      operation = '';
      setState(() {
        text = '';
      });
    }
  }

  _answer() {
    if (text != '' && prevText != '' && operation != '') {
      equalsTo = true;
      _operation(operation);
      text = prevText;
      operation = '';
      setState(() {
        prevText = '';
      });
    }
  }

  void _operation(String op) {
    if (text != '' && prevText != '') {
      switch (operation) {
        case '+':
          prevText =
              (double.parse(text) + double.parse(prevText)).toStringAsFixed(3);
          break;
        case '-':
          prevText =
              (double.parse(prevText) - double.parse(text)).toStringAsFixed(3);
          break;
        case 'x':
          prevText =
              (double.parse(text) * double.parse(prevText)).toStringAsFixed(3);
          break;
        case '/':
          prevText =
              (double.parse(prevText) / double.parse(text)).toStringAsFixed(3);
          operation = op;
          if (!equalsTo) {
            setState(() {
              text = '';
            });
          }
          equalsTo = false;
          break;
        default:
          prevText =
              (double.parse(prevText) % double.parse(text)).toStringAsFixed(3);
          break;
      }
      operation = op;
      if (!equalsTo) {
        setState(() {
          text = '';
        });
      }
      equalsTo = false;
    } else if (text != '') {
      operation = op;
      prevText = text;
      setState(() {
        text = '';
      });
    } else {
      setState(() {
        operation = op;
      });
    }
  }

  void _checkOperand(index) {
    if (index == 3) {
      _clear();
    } else if (num.tryParse(values[index]) != null || values[index] == '.') {
      _showText(values[index]);
    } else if (index == 2) {
      _delete();
    } else if (values[index] == '=') {
      _answer();
    } else if (values[index] == 'sqr') {
      _sqr(values[index]);
    } else {
      _operation(values[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.bottomRight,
            height: MediaQuery.of(context).size.height / 2.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  operation != '' && prevText != ''
                      ? '$prevText $operation'
                      : prevText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 80),
                itemBuilder: (ctx, index) => InkWell(
                  splashColor: Colors.amber,
                  borderRadius: BorderRadius.circular(35),
                  onTap: () {
                    _checkOperand(index);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(15),
                      shape: BoxShape.circle,
                      color: Colors.red[300],
                    ),
                    child: index == 3
                        ? Icon(values[index])
                        : Text(
                            values[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                  ),
                ),
                itemCount: values.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
