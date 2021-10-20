import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'PDS';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)?.settings.arguments as String;

    // if we use listen arg in of() and set it to false then it wont rebuild whenever notify changes called, but by default it set on true
    final productLoaded = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((prod) => prod.id == id);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productLoaded.title),
      // ),

      // adding transition in which when we scroll down image becomes app bar
      //for this we have to wrap our content in customscrollview which gives more previlige as compare to singlechildscrollview
      //takes slivers args
      body: CustomScrollView(
        //slivers are scrollable part on screen
        slivers: [
          SliverAppBar(
            //expandedheight means when instead on app image is visible
            expandedHeight: 300,
            pinned:
                true, //pinned true means whenever the page scroll down appbar will be visible
            //in flexiblespace arg tells what should be inside of appbar
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productLoaded.title),
              //background is the part where we will set the image which will be hide bh appbar other wise picture is visible instead of app bar
              background: Hero(
                tag: productLoaded.id,
                child: Image.network(
                  productLoaded.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\$${productLoaded.price}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    productLoaded.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
