import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/widgets.dart';
import './widgets/chart.dart';

void main() {
  // if we to set mode(landscape or potrait) of our app in which it could be shown we can use this line of code
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.amber,
        //primaryColor: Colors.lime[600],
        primarySwatch: Colors.purple,
        fontFamily: 'OpenSans',
        // managing style for app bar text
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      title: 'Personal Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _usertransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Puma Shoes',
    //   amount: 10000.00,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Haier AC',
    //   amount: 75000.00,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool _switchChart = false;

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(
        this); //when ever the app life cycle changes in initstate addObserver will be created and call didChangeAppLifecycleState
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //when the state of app changes this method will trigger, this will tell the state of app
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance?.removeObserver(
        this); //when ever we close the app in dispose removeObserver will remove the observer/listner and call didChangeAppLifecycleState and
    super.dispose();
  }

  void _addNewTransaction(
      String newtxtitle, double newtxamount, DateTime chosenDate) {
    final newtx = Transaction(
        id: DateTime.now().toString(),
        title: newtxtitle,
        amount: newtxamount,
        date: chosenDate);
    setState(() {
      _usertransactions.add(newtx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Personal Expenses',
//           style: TextStyle(color: Theme.of(context).accentColor),
//         ),
//         actions: [
//           IconButton(
//             color: Theme.of(context).accentColor,
//             onPressed: () => _startNewTransaction(context),
//             icon: Icon(Icons.add),
//           ),
//         ], //action takes list of widget
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           //column takes as much space as much its child needs
//           children: [
//             Charts(_recentTransactions),
//             TransactionList(_usertransactions, _deleteTransaction),
//             /*Card(
//               color: Colors.blue,
//               child: Container(
//                 width: double.infinity,
//                 child: Text('List of TX'),
//                 ),
//               elevation: 5,
//             ),*/
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _startNewTransaction(context),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// Setting resolution of app according to device size using mediaQuery

  @override
  Widget build(BuildContext context) {
    final islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final apBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      actions: [
        IconButton(
          color: Theme.of(context).accentColor,
          onPressed: () => _startNewTransaction(context),
          icon: Icon(Icons.add),
        ),
      ], //action takes list of widget
    );
    final txwidgetlist = Container(
        height: (MediaQuery.of(context).size.height -
                apBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.6,
        child: TransactionList(_usertransactions, _deleteTransaction));
    return Scaffold(
      appBar: apBar,
      body: SingleChildScrollView(
        child: Column(
          //column takes as much space as much its child needs
          children: [
            if (islandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Switch Chart'),
                  Switch(
                      value: _switchChart,
                      onChanged: (val) {
                        setState(() {
                          _switchChart = val;
                        });
                      }),
                ],
              ),
            if (!islandscape)
              Container(
                height: (MediaQuery.of(context)
                            .size
                            .height - //this is size of available space
                        apBar.preferredSize.height - //this is size of appBar
                        MediaQuery.of(context)
                            .padding
                            .top) * //this is the size of device top section where we see battery icon etc
                    0.3, // and we are subracting all these three things and multiplying by 0.4=40%
                //why we are subracting appbar and device top UI size? if u want to know about it then dont subtract apbar and padding from available device size and see the difference
                child: Charts(_recentTransactions),
              ),
            if (!islandscape) txwidgetlist,
            if (islandscape)
              _switchChart
                  ? Container(
                      height: (MediaQuery.of(context)
                                  .size
                                  .height - //this is size of available space
                              apBar.preferredSize
                                  .height - //this is size of appBar
                              MediaQuery.of(context)
                                  .padding
                                  .top) * //this is the size of device top section where we see battery icon etc
                          0.7, // and we are subracting all these three things and multiplying by 0.4=40%
                      //why we are subracting appbar and device top UI size? if u want to know about it then dont subtract apbar and padding from available device size and see the difference
                      child: Charts(_recentTransactions),
                    )
                  : txwidgetlist,
            /*Card(
              color: Colors.blue,
              child: Container(
                width: double.infinity,
                child: Text('List of TX'),
                ),
              elevation: 5,
            ),*/
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
