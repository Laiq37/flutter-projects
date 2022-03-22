import '../models/cart_item.dart';

class OrderItem {
  final String oId;
  final double oAmount;
  final List<CartItem> oItems;
  final DateTime oDate;

  OrderItem(
      {required this.oId,
      required this.oAmount,
      required this.oItems,
      required this.oDate});
}
