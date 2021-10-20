import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  var isfavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isfavourite = false,
  });

  Future<void> toggleFavourite(
      String prodid, String userToken, String userId) async {
    final oldStatus = isfavourite;
    isfavourite = !isfavourite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-shop-update-dd173-default-rtdb.firebaseio.com/userFavoruites/$userId/$id.json?auth=$userToken");
    try {
      final response = await http.put(url, body: json.encode(isfavourite));
      if (response.statusCode >= 400) {
        isfavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      isfavourite = oldStatus;
      notifyListeners();
    }
  }
}
