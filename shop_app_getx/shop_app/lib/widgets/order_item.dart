import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart' as oi;

// ignore: must_be_immutable
class OrderItem extends StatefulWidget {
  
  final oi.OrderItem order;

  bool isExpandable = false;

  OrderItem({ Key? key, required this.order }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: widget.isExpandable ? min(widget.order.oItems.length * 20.0 + 110, 200) : 95,
        curve: Curves.easeInOut,
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.oAmount}'),
              subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.oDate)),
              trailing: IconButton(onPressed: (){
                setState(() {
                  widget.isExpandable = !widget.isExpandable;
                });
              }, icon: const Icon(Icons.arrow_drop_down)),
            ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: widget.isExpandable ? min(widget.order.oItems.length * 20.0 + 10, 100) : 0,
                child: ListView(
                  children: widget.order.oItems
                      .map(
                        (prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    prod.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x \$${prod.price}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}