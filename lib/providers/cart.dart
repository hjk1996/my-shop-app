import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class CartItem {
  final String productId;
  final String imageUrl;
  final int quantity;
  final String title;
  final double price;

  CartItem(
      {required this.productId,
      required this.imageUrl,
      required this.quantity,
      required this.title,
      required this.price});

  double get totalPrice {
    return quantity * price;
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "imageUrl": imageUrl,
      "quantity": quantity,
      "title": title,
      "price": price,
    };
  }
}

class Cart with ChangeNotifier {
  List<Product>? products;
  late Map<String, CartItem>? _cart;

  Cart(this.products, cart) {
    _cart = cart ?? {};
  }

  Map<String, CartItem> get cart {
    return _cart!;
  }

  void addCartItem(String productId) {
    // 이미 카트에 동일한 상품이 존재하는 경우
    if (_cart!.containsKey(productId)) {
      _cart!.update(
          productId,
          (cartItem) => CartItem(
                productId: cartItem.productId,
                imageUrl: cartItem.imageUrl,
                quantity: cartItem.quantity + 1,
                title: cartItem.title,
                price: cartItem.price,
              ));
      notifyListeners();
      // 카트에 동일한 상품이 존재하지 않는 경우
    } else {
      final product =
          products!.firstWhere((product) => product.productId == productId);

      _cart![productId] = CartItem(
          productId: productId,
          imageUrl: product.imageUrl,
          quantity: 1,
          title: product.title,
          price: product.price);
      notifyListeners();
    }
  }

  void removeCartItem(String productId) {
    if (_cart!.containsKey(productId)) {
      _cart!.remove(productId);
    }
  }

  Future<void> makeOrder(String userId) async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/orders/$userId.json");

    final Map<String, dynamic> requestBody = {};
    requestBody["orderDate"] = DateTime.now().toIso8601String();

    final List orderItems = [];
    cart.forEach((key, value) {
      orderItems.add(value.toJson());
    });

    requestBody['orderItems'] = orderItems;

    try {
      final res = await http.post(url, body: json.encode(requestBody));

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }

      _cart!.clear();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
