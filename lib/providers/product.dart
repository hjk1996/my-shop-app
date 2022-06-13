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

  Future<void> toggleFavorite(String id, String token) async {
    final url = Uri.parse(
        "https://udemy-shop-app-dd13c-default-rtdb.firebaseio.com/userFavorites/$id.json?auth=$token");

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final res = await http.put(url, body: json.encode({isFavorite}));
    } catch (error) {
      print(error);
      isFavorite = !isFavorite;
      notifyListeners();
      throw error;
    }
  }
}
