import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/auth.dart';

import '../providers/cart.dart';

class ProductItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context,
        listen: false); //provider rebuild the whole build method
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    print(product.isfavourite);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          // to use hero animation we can wrap the image in hero widget
          //it takes tag which will tell the page which image should be animated,
          //and also wrap that image on the other screen in hero and tag must be same as it has
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //Consumer only rebuild paricular widget which is attach to it, it takes builder funct in which we passes context, value, and child, in consumer if we have multiple  widget and
          //we dont want some widget to rebuild when changes occur then we pass those widget in child
          leading: Consumer<Product>(
            builder: (c, product, child) => IconButton(
              icon: Icon(product.isfavourite == true
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                product
                    .toggleFavourite(
                        product.id, authData.token!, authData.userId!)
                    .then((message) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(
                      content: product.isfavourite
                          ? Text("Added to Favourite!")
                          : Text("Removed from Favourite!")));
                });
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.AddItem(product.id, product.title, product.price);
              // we are accessing here scaffold.of(context) property, we are accessing the nearest scaffold of our app
              // if we wanted to hide previous next bar when ever new item added to cart to show the new snackbar we use hideCurrentSnackbar method

              //in version flutter < 2 we use snackbar like below
              // Scaffold.of(context).hideCurrentSnackBar();
              // Scaffold.of(context).showSnackBar(

              // In version flutter ==2 or higher we can use snacbar like below
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                //a snackbar is an popup message
                SnackBar(
                  //it takes content and we can also set duration of it using duration arg
                  content: Text(
                    "Added item to cart!",
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
