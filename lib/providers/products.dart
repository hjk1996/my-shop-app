import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  String? userId;
  String? token;

  Products(this.userId, this.token);

  List<Product> _products = [];

  List<Product> get products {
    return _products;
  }

  List<Product> get favoritedProducts {
    return _products.where((product) => product.isFavorite == true).toList();
  }

  Future<void> fetchProductsFromServer() async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/products.json?auth=$token");

    final url2 = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token");

    try {
      final res = await http.get(url);
      final res2 = await http.get(url2);

      if (res.statusCode != 200) {
        throw HttpException("HTTP ERROR: ${res.statusCode}");
      }

      final resData = json.decode(res.body) as Map<String, dynamic>;
      final resData2 = json.decode(res2.body) as Map;

      final List<Product> tempProducts = [];

      if (resData.isNotEmpty) {
        resData.forEach((key, item) {
          final bool isFavorite = resData2[key] ?? false;
          tempProducts.add(Product(
              productId: key,
              title: item["title"],
              price: item["price"].toDouble(),
              description: item["description"],
              imageUrl: item["imageUrl"],
              creatorId: item["creatorId"],
              isFavorite: isFavorite));
        });
      }

      _products = tempProducts;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/products/${product.productId}.json?auth=$token");

    try {
      final res = await http.post(url,
          body: json.encode({
            "creatorId": product.creatorId,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title
          }));

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }

      _products.add(product);
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String productId) async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/products/$productId.json?auth=$token");

    try {
      final res = await http.delete(url);

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }

      _products.removeWhere((product) => product.productId == productId);
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/products/${updatedProduct.productId}.json?auth=$token");

    try {
      final res = await http.patch(url,
          body: json.encode({
            "creatorId": updatedProduct.creatorId,
            "description": updatedProduct.description,
            "imageUrl": updatedProduct.imageUrl,
            "price": updatedProduct.price,
            "title": updatedProduct.title
          }));

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }
    } catch (error) {
      throw error;
    }
  }

  Product findProductById(String id) {
    return _products.firstWhere((product) => product.productId == id);
  }
}
