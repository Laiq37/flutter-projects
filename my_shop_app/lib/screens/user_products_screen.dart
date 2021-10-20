import 'package:flutter/material.dart';
//import 'package:my_shop_app/providers/product.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/User-Products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final prodData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (ctx, prodData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                  prodData.items[i].id,
                                  prodData.items[i].title,
                                  prodData.items[i].imageUrl),
                              Divider()
                            ],
                          ),
                          itemCount: prodData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
