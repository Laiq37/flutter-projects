import 'package:flutter/widgets.dart';
import '../models/order_item.dart';
import '../models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class OrderController with ChangeNotifier {
  final String? authToken;
  final String? userId;

  OrderController(
    this.authToken,
    this.userId,
  );

  final RxList<OrderItem> _oList = <OrderItem>[].obs;

  List<OrderItem> get oList => [..._oList];

//  void addOrders(List<CartItem> oItem, double oAmount){
//    _oList.insert(0, OrderItem(oId: DateTime.now().toString(), oAmount: oAmount, oItems: oItem, oDate: DateTime.now()));
//  }

  Future<void> fetchAndSetOrders() async {
    final String url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final Map<String, dynamic>? extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          oId: orderId,
          oAmount: orderData['amount'],
          oDate: DateTime.parse(orderData['dateTime']),
          oItems: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _oList.value = loadedOrders.reversed.toList();
    _oList.refresh();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final String url =
        'https://shop-app-efa02-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _oList.insert(
      0,
      OrderItem(
        oId: json.decode(response.body)['name'],
        oAmount: total,
        oDate: timestamp,
        oItems: cartProducts,
      ),
    );
    _oList.refresh();
  }
}
