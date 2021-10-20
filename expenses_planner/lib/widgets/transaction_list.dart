import 'package:expenses_planner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Single child Scroll view
/*class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: SingleChildScrollView(
        child: Column(
          children: transactions.map((tx) {
            return Card(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Rs/= ${tx.amount}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(tx.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}*/

/*class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: ListView(
        children: transactions.map((tx) {
          return Card(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Rs/= ${tx.amount}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.purple),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().format(tx.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}*/

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 475,
        child: transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constrainsts) {
                return Column(
                  children: [
                    Text(
                      "No transaction Added yet!",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      //size box is a box which have height wdith child argument and we can use all of them or any of them
                      height: 20,
                    ),
                    Container(
                      height: constrainsts.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/image/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              })
//             : ListView.builder(
//                 itemBuilder: (ctx, index) {
//                   return Card(
//                     child: Row(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 10),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Theme.of(context).primaryColor,
//                               width: 2,
//                             ),
//                           ),
//                           child: Text(
//                             'Rs/= ${transactions[index].amount.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               transactions[index].title,
//                               style: Theme.of(context).textTheme.title,
//                             ),
//                             Text(
//                               DateFormat.yMMMd()
//                                   .format(transactions[index].date),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).accentColor,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: transactions.length,
//               ));
//   }
// }

// replacing card with list tile view
            : ListView.builder(
                itemCount: transactions.length,
                //if we dont pass the item count argument we will get exception of rangeError(index)
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 30, //size of circle widget
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            // it compressed the size of widget child element according to space of widget
                            child: Text(
                              'Rs/= ${transactions[index].amount}',
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(DateFormat.yMMMMd().format(
                        transactions[index].date,
                      )),
                      trailing: MediaQuery.of(context).size.width > 460
                          ? FlatButton.icon(
                              onPressed: () => deletetx(transactions[index].id),
                              icon: Icon(Icons.delete),
                              label: Text(
                                'Delete',
                              ),
                              textColor: Theme.of(context).errorColor,
                            )
                          : IconButton(
                              onPressed: () => deletetx(transactions[index].id),
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                            ),
                    ),
                  );
                }));
  }
}
