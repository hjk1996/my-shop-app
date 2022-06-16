import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../screens/order_screen.dart';
import '../providers/auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text(
              "My Shop",
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
              leading: const Icon(Icons.enhanced_encryption),
              title: const Text("Products"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Cart"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chrome_reader_mode_outlined),
            title: const Text("Orders"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                    onTap: () async {
                      await Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: const Chip(label: Text("Logout"), elevation: 5)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
