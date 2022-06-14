import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String productId;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final String creatorId;
  bool isFavorite;

  Product({
    required this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.creatorId,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String userId, String token) async {
    final url = Uri.parse(
        "https://my-shop-app-e2b46-default-rtdb.firebaseio.com/userFavorites/$userId/$productId.json?auth=$token");

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final res = await http.put(url, body: json.encode(isFavorite));
      print(json.decode(res.body));
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
