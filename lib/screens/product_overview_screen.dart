import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_grid_cell.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Shop")),
      body: FutureBuilder(
        future: productsProvider.fetchProductsFromServer(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.count(
                crossAxisCount: 2,
                children: productsProvider.products
                    .map((product) => ProductGridCell(
                          product.productId,
                          product.imageUrl,
                          product.title,
                          product.isFavorite,
                        ))
                    .toList());
          }
        },
      ),
    );
  }
}
