import 'package:flutter/material.dart';

import 'package:get/get.dart';
import './providers/auth.dart';

import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authController = Get.put(Auth());

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (context) => Auth(),
    //     ),
    //     ChangeNotifierProxyProvider<Auth, ProductController?>(
    //       create: (_) => null,
    //       update: (context, auth, previousProducts) => ProductController(
    //           auth.token,
    //           auth.userId,
    //           previousProducts == null ? [] : previousProducts.getItems),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => CartController(),
    //     ),
    //     ChangeNotifierProxyProvider<Auth, OrderController?>(
    //       create: (_) => null,
    //       update: (context, auth, previousOrders) => OrderController(auth.token,
    //           auth.userId, previousOrders == null ? [] : previousOrders.oList),
    //     ),
    //   ],
    //   child: Consumer<Auth>(
    //     builder: (ctx, auth, _) =>
    return GetMaterialApp(
      title: 'My Shop App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple[300]!, secondary: Colors.orange),
          fontFamily: 'Lato'),
      home: Obx(() => authController.isAuth.value
          ? ProductOverviewScreen()
          : FutureBuilder(
              future: authController.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? const SplashScreen()
                      : const AuthScreen(),
            )),

      // routes: {
      //   ProductDetailScreen.routeName: (context) =>
      //       const ProductDetailScreen(),
      //   CartScreen.routeName: (context) => const CartScreen(),
      //   OrderScreen.routeName: (context) => const OrderScreen(),
      //   EditProductScreen.routeName: (context) => EditProductScreen(),
      //   UserProductsScreen.routeName: (context) =>
      //       const UserProductsScreen(),
      // },
      getPages: [
        GetPage(
            name: ProductDetailScreen.routeName,
            page: () => const ProductDetailScreen()),
        GetPage(name: CartScreen.routeName, page: () => const CartScreen()),
        GetPage(name: OrderScreen.routeName, page: () => OrderScreen()),
        GetPage(
            name: EditProductScreen.routeName, page: () => EditProductScreen()),
        GetPage(
            name: UserProductsScreen.routeName,
            page: () => UserProductsScreen())
      ],
    );
  }
}
