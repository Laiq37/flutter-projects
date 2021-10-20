import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String? userToken;
  final String? userId;

  Orders(this.userToken, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final firebasebackendname = "Enter Your backend database name";
    final url = Uri.parse(
        "https://$firebasebackendname.firebaseio.com/orders/$userId.json?auth=$userToken");
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    try {
      final extractedData = json.decode(response.body) as Map<String?, dynamic>;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId!,
            amount: orderData["amount"],
            products: (orderData["products"] as List<dynamic>)
                .map((item) => CartItem(
                    id: item["id"],
                    price: item["price"],
                    quantity: item["quantity"],
                    title: item["title"]))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final firebasebackendname = "Enter Your backend database name";
    final url = Uri.parse(
        "https://$firebasebackendname.com/orders/$userId.json?auth=$userToken");
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartproducts
              .map(
                (cp) => {
                  "id": cp.id,
                  "price": cp.price,
                  "quantity": cp.quantity,
                  "title": cp.title
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartproducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
