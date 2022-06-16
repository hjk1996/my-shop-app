import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:badges/badges.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

class CartIconBadge extends StatelessWidget {
  const CartIconBadge({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Badge(
          position: BadgePosition.topStart(top: 0, start: 22),
          badgeContent: Text("${cart.cart.length}"),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart_sharp)),
        );
      },
    );
  }
}
