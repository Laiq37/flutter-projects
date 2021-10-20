import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// as we have different class with same name and we want to use both these class in same file so while importing them we use "as anyname" convention or use "show particular_class_name_which_will_be_used_in_that_particular_file"
import '../widgets/cart_item.dart' as ci;
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Orderbutton(cart: cart)
                ],
              ),
            ),
          ),
          // as we know we cant use listview builder directly in column wewe can wrap it in expanded widget so it will get all the remaining screen on the screen
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => ci.CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}

class Orderbutton extends StatefulWidget {
  Orderbutton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderbuttonState createState() => _OrderbuttonState();
}

class _OrderbuttonState extends State<Orderbutton> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isloading = false;
              });
              widget.cart.clearCart();
            },
      child: _isloading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
