import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop_app/models/http_exception.dart';
import 'product.dart';

//to communicate with server we have import package http/http.dart, before importing it we also have to set' http: ^0.13.3' in pubspec.yaml in dependicies section
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String? userToken;
  final String? userId;

  Products(this.userToken, this.userId, this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [
      ..._items.reversed
    ]; // these 3dots merge the list within new list like it is the part of the
  }

  List<Product> get favItems {
    return _items
        .where((prod) => prod.isfavourite)
        .toList(); //[..._items.where((prod) => prod.isfavourite)]
  }

  Product findById(String prodid) {
    return _items.firstWhere((item) => item.id == prodid);
  }

  //by making our function future it will return something after the function completely process
  // Future<void> addProduct(Product product) {
  //   //first we have to create a var of anyname but better to use url and then in var we call Uri.https/http() method in which we passes to arg one is actual arg and the other is folder/path/table name to be created
  //   // we can request from multiple ways all can work

  //   //-1
  //   var url = Uri.https(
  //       "flutter-shop-update-dd173-default-rtdb.firebaseio.com", "/products.");

  //   //-2
  //   // var url = Uri.parse(
  //   //     "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/products.json");
  //   //post return a future in which we have reponse of our request and also our data in json encoded form which we can also decode

  //   return http
  //       .post(
  //     url,
  //     body: json.encode(
  //       {
  //         'title': product.title,
  //         'price': product.price,
  //         'description': product.description,
  //         'imageUrl': product.imageUrl,
  //         'isFavourite': product.isfavourite,
  //       },
  //     ),
  //   )
  //       .then(
  //     (response) {

  //       //for decoding we use json.decode() method and in that we passes our reponse arg with which part of response we wanted to access(means headers, body, etc)

  //       final res = json.decode(response.body);
  //       product = Product(
  //           id: res['name'],
  //           title: product.title,
  //           price: product.price,
  //           description: product.description,
  //           imageUrl: product.imageUrl);
  //       _items.add(product);
  //       //_items.add(value);
  //       notifyListeners();
  //     },

  //     // catchError will error of post and then, we can also place catchError before .then block but then catch error will only catch error of .post, that's why we place the catch block after
  //     //.then block so it will also catch error of then block, if .post block will have any error then .then block would be skip,

  //   ).catchError(
  //     (error) {
  //       print(error);
  //       throw error;
  //     },
  //   );
  // }

  //oR

// async works as same as future behind the scene and also it yeilds the future so we dont need to return
// in edit_product_screen.dart where we are using this addProduct function, we can still use .catcherror and .then method there
  Future<void> addProduct(Product product) async {
    try {
      var url = Uri.parse(
          "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/products.json?auth=$userToken");
      //we can use await with those items which can return the response
      //to get the response we can store in a variable

      //to catch error we can use try and catch block
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );

      //now this block will run instantly right after await
      final res = json.decode(response.body);
      product = Product(
        id: res['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(product);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    // we are filtering data by creatorId to show user only that products at manage screen which is created by that user
    //in our api after .json ? is to pass parameter which are optional and & for filtering the data
    // to use firebase server side filtering we have to use it right after parameters in firebase api below is example '&orderBy="keyBywhichfilter"&equalTo="valueByWhichOrderByValueWillBeCompared"'
    final String filterByUserString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/products.json?auth=$userToken&$filterByUserString');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedProduct = json
          .decode(
              response.body) as Map<String,
          dynamic>; //we set it to Map<String, dynamic> b/c it will return a map with keys of string and value of map type,
      //for value instead of map we used dynamic type b/c dart wont understand nested map type
      if (extractedProduct == null) {
        return;
      }
      url = Uri.parse(
          "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/userFavoruites/$userId.json?auth=$userToken");
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Product> _loadedProducts = [];
      extractedProduct.forEach((key, value) {
        _loadedProducts.add(Product(
            id: key,
            price: value['price'],
            description: value['description'],
            title: value['title'],
            imageUrl: value['imageUrl'],
            //?? checks wheter the value is null or not
            isfavourite: favData == null ? false : favData[key] ?? false));
      });
      _items = _loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProd) async {
    final prodIndex = _items.indexWhere((pd) => pd.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/products/$id.json?auth=$userToken");
      await http.patch(url,
          body: json.encode({
            'title': newProd.title,
            'price': newProd.price,
            'description': newProd.description,
            'imageUrl': newProd.imageUrl
          }));
      _items[prodIndex] = newProd;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/products/$id.json?auth=$userToken");
    final _existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? _existingProduct = _items[_existingProductIndex];
    _items.removeAt(_existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException("Failed to Delete the Product!");
    }
    _existingProduct = null;
  }
}
