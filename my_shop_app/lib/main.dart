import 'package:flutter/material.dart';
import 'package:my_shop_app/helpers/custom_route.dart';
import 'package:my_shop_app/providers/auth.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/orders.dart';
import 'package:my_shop_app/screens/auth_screen.dart';
import 'package:my_shop_app/screens/cart_screen.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart'; // we use provider package in parent class of child(where data will be used)

import './screens/product_detail_screen.dart';

import './providers/products.dart';

import './screens/product_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // to use provider we have to wrap materialApp in ChangeNotifierProvider and use "create" arg(if version == or > 4)/builder(version == 3) and in it we passes a anounymus fucnction which have build
    // context as arg and our created provider class
    //changenotifierProvider also has .value method if use this then instead of create we use value and pass our desired provider class, we can use this method when we dont need context
    // when instantiating our provider for first time better to dont use ChangeNotifierProvider.value instead use ChangeNotifierProvider
    //changeNotifier cleans the memory when we wont need the widget which has proivder
    //changeNotifierProvider.value is useful with list and grid, as we know in list and grid view flutter only create those item which can be viewable on screen so when we use .value method when
    //we scroll down and then scroll up again it will recycle the last state of item, and if we use only changeNotifierProvider then we might face bugs

    // return ChangeNotifierProvider(
    //   create: (ctx) => Products(),

    //two use multiple provide we can use Multiproviders class which is available in provider.dart

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          // ChangeNotifierProvider(create: (ctx) => Products()),

          //if our any provider class depends on any other provider class and want data from that class then we can use change ChangeNotifierProxyProvider if our object is depends on 1 provider
          //class else we can ChangeNotifierProxyProvider2,3,4,5,6 it depends on how much provider class that object depends, note the dependent provider class object must be place after required
          // provider class
          //ChangeNotifierProxyProvider takes 2 types of  data one on which the object depend on and the other is Object
          // update takes function with arg ctx, datao on which object depend and the previous object

          ChangeNotifierProxyProvider<Auth, Products?>(
            create: (_) {
              //print('auth with prod');
              return null;
            },
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),

          ChangeNotifierProvider(create: (ctx) => Cart()),

          //ChangeNotifierProvider(create: (ctx) => Orders()),
          ChangeNotifierProxyProvider<Auth, Orders?>(
            create: (_) => null,
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primaryColor: Colors.purple,
                accentColor: Colors.deepOrange,
                //to use our CustomRoute we use a pageTransitionTheme arg which takes PageTransitionsTheme and this takes a builders arg which take a map
                //in this map key is TargetPlatform and value should be our CustomRoutePageTransition class instance or default transition instance
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomRoutePageTransition(),
                  TargetPlatform.iOS: CustomRoutePageTransition(),
                }),
                fontFamily: "Lato"),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : authResultSnapShot.data == true
                                ? ProductOverviewScreen()
                                : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
