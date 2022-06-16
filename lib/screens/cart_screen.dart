import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/auth.dart';
import '../widgets/drawer.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "cart-screen";

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          actions: [
            IconButton(
                onPressed: () async {
                  await cartProvider.makeOrder(authProvider.userId!);
                },
                icon: Icon(Icons.add_card))
          ],
        ),
        drawer: MyDrawer(),
        body: Consumer<Cart>(
          builder: (context, cart, child) => Container(
            child: ListView.builder(
              itemCount: cart.cart.length,
              itemBuilder: (ctx, idx) {
                final cartItemKeyValue = cart.cart.entries.toList()[idx];
                return Dismissible(
                  key: ObjectKey(cartItemKeyValue),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    cart.removeCartItem(cartItemKeyValue.key);
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(cartItemKeyValue.value.imageUrl),
                          ),
                          title: Text(cartItemKeyValue.value.title),
                          subtitle: Text(
                              "Quantity: ${cartItemKeyValue.value.quantity}, Total Price: ${cartItemKeyValue.value.totalPrice}"),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
