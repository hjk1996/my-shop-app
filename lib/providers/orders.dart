import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order {
  final String orderId;
  final DateTime orderDate;
  final List<dynamic> orderedItems;

  Order(
      {required this.orderId,
      required this.orderDate,
      required this.orderedItems});

  bool expanded = false;

  double get totalPrice {
    return orderedItems.fold<double>(
        0,
        (previousValue, item) =>
            previousValue + item['price'] * item['quantity']);
  }
}

class Orders with ChangeNotifier {
  final String? userId;
  final String? token;

  Orders(this.userId, this.token);

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchOrdersFromServer() async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/orders/$userId.json?");

    try {
      final res = await http.get(url);

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}") as Map<String, Map>;
      }

      final resData = json.decode(res.body);

      final List<Order> temp_orders = [];
      resData.forEach((orderId, data) {
        temp_orders.add(Order(
            orderId: orderId,
            orderDate: DateTime.parse(data['orderDate']),
            orderedItems: data['orderItems']));
      });
      _orders = temp_orders;
    } catch (error) {
      rethrow;
    }
  }
}
