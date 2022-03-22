import 'package:get/get.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  final RxMap<String, CartItem> _cart = <String, CartItem>{}.obs;

  Map<String, CartItem> get cart => {..._cart};

  int get itemCount => _cart.length;

  void addItem(String id, String title, double price) {
    if (_cart.containsKey(id)) {
      _cart.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        )..obs,
      );
    } else {
      _cart.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toIso8601String(),
            title: title,
            price: price,
            quantity: 1)
          ..obs,
      );
    }
    _cart.refresh();
  }

  void updateCartItemDetail(
    String id,
    String? title,
    double? price,
  ) {
    if (_cart.containsKey(id)) {
      _cart.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: title ?? existingItem.title,
          price: price ?? existingItem.price,
          quantity: existingItem.quantity,
        )..obs,
      );
    }
  }

  Rx<double> get carttotal {
    Rx<double> totalAmount = 0.0.obs;
    _cart.forEach((key, cartItem) {
      totalAmount += cartItem.price * cartItem.quantity;
    });
    return totalAmount;
  }

  void removeSingleItem(
    String id,
  ) {
    if (!_cart.containsKey(id)) {
      return;
    } else if (_cart[id]!.quantity > 1) {
      _cart.update(
          id,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              )..obs);
    } else {
      _cart.remove(id);
    }
    _cart.refresh();
  }

  void removeItem(id) {
    _cart.removeWhere((key, value) => key == id);
    _cart.refresh();
  }

  void clearCart() {
    _cart.clear();
    _cart.refresh();
  }
}
