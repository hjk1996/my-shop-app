import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductGridCell extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final bool isFavorite;

  ProductGridCell(this.productId, this.imageUrl, this.title, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context, listen: false)
        .findProductById(productId);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4.0,
      child: Container(),
    );
  }
}
