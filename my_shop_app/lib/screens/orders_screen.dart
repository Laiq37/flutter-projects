import 'package:flutter/material.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "orders";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const routeName = "/orders";

  //to make sure that if any other widget is using build method so our fetch and set order wont again that's why we initializing at top
  Future? _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  // bool _isloading = false;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   //Future.delayed(Duration.zero).then((_) async {
  //   // setState(() {
  //   _isloading = true;
  //   // });
  //   Provider.of<Orders>(context,
  //           listen:
  //               false) // we cnt use modalroute.of(context) in init state b/c it dont has listen arg which we have to set at false
  //       .FetchAndSetOrders()
  //       .then((_) => {
  //             setState(() {
  //               _isloading = false;
  //             })
  //           });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context); we cant use this here b/c if we still use it here we will be trap in infinite loop
    //b/c whenever fetandsetorder method executed and notifylistner runs and here provider package listen is true so the whole build run again
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),

        //Future builder method take future and then start listening to .then and catch method
        //future bultder takes context and snapshot(current date return by future)
        //snapshot is type of async snapshot so we can use then and catch
        body: FutureBuilder(
            builder: (ctx, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapShot.error != null) {
                  return Center(
                    child: Text("An error Occured!"),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                            itemCount: orderData.orders.length,
                          ));
                }
              }
            },
            future: _orderFuture
            //Provider.of<Orders>(context, listen: false).FetchAndSetOrders(),
            ));
  }
}
