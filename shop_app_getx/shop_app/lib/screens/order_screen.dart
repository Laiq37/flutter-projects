import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_drawer.dart';

import '../providers/order_controller.dart';
import '../widgets/order_item.dart';
import '../providers/order_controller.dart' show OrderController;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  final orderController = Get.find<OrderController>();

  OrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final OrderController oProvider = Provider.of<OrderController>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: orderController.fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(
                  order: orderController.oList[i],
                ),
                itemCount: orderController.oList.length,
              );
            }
          }
        },
      ),
    );
  }
}
