import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../providers/cart_controller.dart';
import '../providers/product_controller.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  ProductItem({required this.id, Key? key}) : super(key: key);

  final String id;

  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final item = productController.findById(id);
    // final CartController cart = Provider.of<CartController>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Get.to(ProductDetailScreen.routeName, arguments: id),
          child: Hero(
            tag: id,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                item.value.imageUrl,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
                onPressed: () async {
                  await productController.toggleProductFav(item.value);
                },
                color: Colors.orange,
                icon: Obx(() {
                  return Icon(item.value.isFavorite
                      ? Icons.favorite_sharp
                      : Icons.favorite_border);
                })),
            title: Text(item.value.title),
            trailing: IconButton(
                onPressed: () {
                  cartController.addItem(
                      id, item.value.title, item.value.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Added item to cart!',
                      ),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cartController.removeSingleItem(item.value.id);
                        },
                      ),
                    ),
                  );
                },
                color: Theme.of(context).colorScheme.secondary,
                icon: const Icon(Icons.shopping_cart))),
      ),
    );
  }
}
