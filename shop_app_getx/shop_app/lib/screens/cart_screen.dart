import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../providers/cart_controller.dart';
import '../providers/order_controller.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('Total'),
                const Spacer(),
                Chip(
                  label: Obx(
                    (() => Text('\$${cart.carttotal.toStringAsFixed(2)}')),
                  ),
                ),
                OrderButton(cart: cart)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              (() => ListView.builder(
                    itemCount: cart.cart.length,
                    itemBuilder: (ctx, i) => ci.CartItem(
                      cart.cart.values.toList()[i].id,
                      cart.cart.keys.toList()[i],
                      cart.cart.values.toList()[i].price,
                      cart.cart.values.toList()[i].quantity,
                      cart.cart.values.toList()[i].title,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartController cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  final order = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.carttotal <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await order.addOrder(widget.cart.cart.values.toList(),
                    widget.cart.carttotal.value);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              },
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Order Now'));
  }
}
