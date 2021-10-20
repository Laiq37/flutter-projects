import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  // 1st way of fetching input data from text field
  // create varaible according to textfield with type of string
  /*String? titleInput;
  String? amountInput;*/

  //2nd Way of fetching input data from text field
  // create varaible as much we have inputs and assign TextEditingController constructor in it
  final Function ftx;

  NewTransaction(this.ftx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime? _selectedDate;

  void _submitted() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredtitle = titleController.text;
    final enteredamount = double.parse(amountController.text);

    if (enteredtitle == "" || enteredamount <= 0 || _selectedDate == null) {
      return;
    }
    widget.ftx(titleController.text, double.parse(amountController.text),
        _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                /*onChanged: (val) {
                        titleInput = val;
                      },*/
                controller:
                    titleController, //it take controller variable(in which we initiate TextEditingController constructor)
                onSubmitted: (_) => _submitted(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                //1st way of fetching textfield input
                //we use onchanged parameter and pass an anonymous function and assign values to variable which we have created above
                /*onChanged: (val) {
                        amountInput = val;
                      },*/
                controller: amountController,
                onSubmitted: (_) =>
                    _submitted(), //in onsubmitted argument we will get a value if we dont want to use it we can use _, it dont
                //have any particular function but it means we recieved value but we wont use it
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked Date: ${DateFormat.yMd().format((_selectedDate as DateTime))}'),
                  FlatButton(
                      textColor: Theme.of(context).accentColor,
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Container(
                //alignment: Alignment.center,
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Theme.of(context).textTheme.button?.color,
                  onPressed:
                      _submitted, /*() {
                    //1st way print: print('Title : ${titleInput}\nAmount : ${amountInput}');
                    /*print(
                        'Title : ${titleController.text}\nAmount : ${amountController.text}');*/ //to get value from controller variable we use c
                    //controller variablename.text syntax
                    
                  }*/
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
