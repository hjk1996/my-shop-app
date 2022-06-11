import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_key.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _id;
  DateTime? _expiryDate;

  bool get IsAuth {
    if (_token == null || _id == null || _expiryDate == null) {
      return false;
    }

    if (_expiryDate!.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }

  String? get token {
    return _token;
  }

  Future<void> signIn() async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY");
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY");

    final res = await http.post(url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));

    print(res.body);
  }
}
