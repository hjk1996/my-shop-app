import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_grid_cell.dart';
import '../widgets/drawer.dart';
import '../widgets/cart_icon_badge.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  static const routeName = "product-overview";

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _showFavorites = !_showFavorites;
                });
              },
              icon: const Icon(Icons.favorite)),
          CartIconBadge()
        ],
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: productsProvider.fetchProductsFromServer(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Products>(
              builder: (context, products, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await products.fetchProductsFromServer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 250),
                      itemCount: _showFavorites
                          ? products.favoritedProducts.length
                          : products.products.length,
                      itemBuilder: (ctx, idx) {
                        // ChangeNotifierProvider.value??? ?????? ???????????? provider??? ???????????? ?????? ???????????? ??????.
                        // Products provider?????? Product provider?????? ???????????? ??????.
                        // ????????? Products provider??? ?????? Product provider??? ?????????.
                        return ChangeNotifierProvider.value(
                          value: _showFavorites
                              ? products.favoritedProducts[idx]
                              : products.products[idx],
                          child: ProductGridCell(),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
