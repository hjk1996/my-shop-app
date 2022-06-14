import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "cart-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Cart")), body: Container());
  }
}
