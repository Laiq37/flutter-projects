import 'package:get/get.dart';
import '../models/http_exception.dart';

import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  final String? authToken;
  final String? userId;

  ProductController(this.authToken, this.userId);

  final _items = <Product>[].obs;

  List<Product> get getItems => [..._items];

  List<Product> get getFavItems =>
      [..._items.where((item) => item.isFavorite == true)].toList();

  Rx<Product> findById(String id) =>
      _items.firstWhere((prod) => prod.id == id).obs;

  void _setFavValue(bool newValue, Product item) {
    item.isFavorite = newValue;
  }

  Future<void> toggleProductFav(Product item) async {
    final oldStatus = item.isFavorite;
    item.obs;
    item.isFavorite = !item.isFavorite;
    final url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/userFavorites/$userId/${item.id}.json?auth=$authToken';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          item.isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus, item);
      }
    } catch (error) {
      _setFavValue(oldStatus, item);
    }
    _items.refresh();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    String url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-efa02-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        )..obs);
      });
      _items.value = loadedProducts;
      _items.refresh();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final String url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      ).obs;
      _items.add(newProduct.value);
      _items.refresh();
      // _items.insert(0, newProduct); // at the start of the list
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-efa02-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      _items.refresh();
    } else {
      // print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    String url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product.');
    }
    url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    await http.delete(Uri.parse(url));
    existingProduct = null;
    _items.refresh();
  }
}
