import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  String? token;

  Products(this.token);

  final List<Product> _products = [];

  List<Product> get products {
    return _products;
  }

  List<Product> get favoritedProducts {
    return _products.where((product) => product.isFavorite == true).toList();
  }

  Future<void> fetchProductsFromServer() async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/products.json?auth=$token");

    try {
      final res = await http.get(url);

      if (res.statusCode != 200) {
        throw HttpException("HTTP ERROR: ${res.statusCode}");
      }

      final resData = json.decode(res.body) as Map<String, dynamic>;

      if (resData.isNotEmpty) {
        resData.forEach((key, item) {
          _products.add(Product(
            productId: key,
            title: item["title"],
            price: item["price"].toDouble(),
            description: item["description"],
            imageUrl: item["imageUrl"],
            creatorId: item["creatorId"],
          ));
        });
      }

      print(products);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct() async {}

  Future<void> removeProduct(String productId) async {}

  Product findProductById(String id) {
    return _products.firstWhere((product) => product.productId == id);
  }
}
