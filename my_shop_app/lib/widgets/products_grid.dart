import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_items.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfav;

  ProductsGrid(this.showfav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showfav ? productData.favItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      // SliverGridDelegateWithFixedCrossAxisCount is used when we have to specify no. of item in a row
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItems(),
      ), // i refers to index
    );
  }
}
