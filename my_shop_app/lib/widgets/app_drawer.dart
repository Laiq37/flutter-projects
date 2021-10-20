import 'package:flutter/material.dart';
import 'package:my_shop_app/helpers/custom_route.dart';
import 'package:provider/provider.dart';

import 'package:my_shop_app/screens/orders_screen.dart';
import 'package:my_shop_app/screens/user_products_screen.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              "Welcome!",
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              "Shop",
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              "Orders",
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);

              //now we dont this because we set our custom route transition for all page in main dart
              // Navigator.of(context).pushReplacement(
              //   CustomeRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              "Manage Products",
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text(
                "Log-Out",
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
