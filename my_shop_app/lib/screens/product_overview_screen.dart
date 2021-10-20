import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/screens/cart_screen.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/badge.dart';
import 'package:my_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

enum filterOptions {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourites = false;
  bool _init = true;
  bool _isLoading = false;
  @override
  void initState() {
    //of(context) wont work in initstate directly b/c initState runs at the very beginning when the widgets are intializing and at that time context of app wont available
    //Provider.of<Products>(context).fetchAndSetProduct();

    //but we can still use of(context) in initstate as shown below
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // }); //this is a hack but not the best approach, best approach is to call it in didChangeDependencies method by overriding it

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false; // we can also use this in initstate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: [
            PopupMenuButton(
              onSelected: (filterOptions selectedValue) {
                setState(
                  () {
                    if (selectedValue == filterOptions.favourites) {
                      _showFavourites = true;
                    } else {
                      _showFavourites = false;
                    }
                  },
                );
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  child: Text('Only Favourite'),
                  value: filterOptions.favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: filterOptions.all,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavourites));
  }
}
