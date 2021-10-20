import 'package:flutter/material.dart';

import 'package:my_shop_app/screens/edit_product_screen.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(
        context); // we cant use of(context) inside future or async so were are storing it in a variable outside onpressed async method
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              icon: Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
