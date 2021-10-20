import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String pid;
  final String title;
  final double price;
  final int quantity;

  CartItem(
    this.id,
    this.pid,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(pid);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    "Are Your Sure?",
                  ),
                  content: Text(
                    "Do you want to remove item from the cart?",
                  ),
                  actions: [
                    FloatingActionButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      backgroundColor: Theme.of(ctx).primaryColor,
                    ),
                    FloatingActionButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      backgroundColor: Theme.of(ctx).primaryColor,
                    )
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text(
                  '\$$price',
                  style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.title!.color),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(
              title,
            ),
            subtitle: Text(
              "\$${price * quantity}",
            ),
            trailing: Text(
              "x$quantity",
            ),
          ),
        ),
      ),
    );
  }
}
