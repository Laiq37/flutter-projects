import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../providers/product_controller.dart';

import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isFav;

  const ProductGrid({required this.isFav, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Get.find<ProductController>();
    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount:
            !isFav ? product.getItems.length : product.getFavItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, itemNo) => ProductItem(
          id: !isFav
              ? product.getItems[itemNo].id
              : product.getFavItems[itemNo].id,
        ),
      ),
    );
  }
}
