import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';

class ProductGridCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
            arguments: product.productId);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 7,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Image(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(),
                        child: Text(
                          product.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.indigo,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        LikeButton(auth: auth),
                        ToCartButton(product: product)
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class ToCartButton extends StatelessWidget {
  const ToCartButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Provider.of<Cart>(context, listen: false)
              .addCartItem(product.productId);
        },
        icon: Icon(Icons.shopping_bag_outlined));
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(builder: (context, prod, child) {
      return IconButton(
          onPressed: () async {
            try {
              await prod.toggleFavorite(auth.userId!, auth.token!);
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Something went wrong! [$error]")));
            }
          },
          icon: Icon(prod.isFavorite
              ? Icons.favorite
              : Icons.favorite_border_outlined));
    });
  }
}
