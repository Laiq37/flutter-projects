import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/providers/auth.dart';
import '../models/enums.dart';
import '../providers/cart_controller.dart';
import '../providers/product_controller.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

// ignore: must_be_immutable
class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);
  bool isFav = false;
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  final authController = Get.find<Auth>();
  late CartController cartController = Get.find<CartController>();

  final ProductController productsController = Get.find<ProductController>();
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      productsController.fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Show Favorite'),
                value: ShowProd.favorite,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: ShowProd.all,
              )
            ],
            onSelected: (ShowProd val) {
              val == ShowProd.favorite
                  ? widget.isFav = true
                  : widget.isFav = false;
              setState(() {});
            },
          ),
          Obx(
            () => Badge(
                child: IconButton(
                  onPressed: () => Get.toNamed(CartScreen.routeName),
                  icon: const Icon(Icons.shopping_cart),
                ),
                value: cartController.itemCount.toString()),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(isFav: widget.isFav),
    );
  }
}
