import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_key.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  // 유저가 authenticated 됐나?
  bool get isAuth {
    if (_token == null || _userId == null || _expiryDate == null) {
      return false;
    }

    if (_expiryDate!.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    return _token;
  }

  Future<void> loadAuthDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = prefs.getString("expiryDate") == null
        ? null
        : DateTime.parse(prefs.getString("expiryDate")!);

    if (expiryDate != null && expiryDate.isAfter(DateTime.now())) {
      _token = prefs.getString("token");
      _userId = prefs.getString("userId");
      _expiryDate = expiryDate;
      final now = DateTime.now();
      final secondsLeft = expiryDate.difference(now).inSeconds;
      _logoutTimer = Timer(Duration(seconds: secondsLeft), logout);
      print(secondsLeft);
    }
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY");

    try {
      final res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }

      final resData = json.decode(res.body) as Map<String, dynamic>;
      final expiresIn = int.parse(resData["expiresIn"]);
      _token = resData["idToken"];
      _userId = resData["localId"];
      _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

      final prefs = await SharedPreferences.getInstance();

      prefs.setString("token", _token!);
      prefs.setString("userId", _userId!);
      prefs.setString("expiryDate", _expiryDate!.toIso8601String());

      _setLogoutTmer(expiresIn);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _userId = null;
    _expiryDate = null;
    _logoutTimer!.cancel();
    _logoutTimer = null;
    await prefs.remove("token");
    await prefs.remove("userId");
    await prefs.remove("expiryDate");
    notifyListeners();
  }

  void _setLogoutTmer(int seconds) {
    _logoutTimer = Timer(Duration(seconds: seconds), logout);
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY");

    try {
      final res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      if (res.statusCode != 200) {
        throw HttpException("${res.statusCode}");
      }
    } catch (error) {
      throw error;
    }
  }
}
