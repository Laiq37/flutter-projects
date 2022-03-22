import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  final authContoller = Get.find<Auth>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text("Hi!"),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Shop'),
          onTap: () => Get.offNamed('/'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.payment,
          ),
          title: const Text('Orders'),
          onTap: () => Get.offNamed(OrderScreen.routeName),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage Products'),
          onTap: () {
            Get.offNamed(UserProductsScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Get.back();
            Get.offNamed('/');

            // Navigator.of(context)
            //     .pushReplacementNamed(UserProductsScreen.routeName);
            authContoller.logout();
          },
        ),
      ],
    ));
  }
}
