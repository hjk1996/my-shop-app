import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_grid_cell.dart';
import '../widgets/drawer.dart';
import '../widgets/cart_icon_badge.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  static const routeName = "product-overview";

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: const [CartIconBadge()],
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
                      itemCount: products.products.length,
                      itemBuilder: (ctx, idx) {
                        // ChangeNotifierProvider.value는 이미 만들어진 provider를 제공하기 위해 사용하면 좋음.
                        // Products provider에는 Product provider들이 리스트로 있음.
                        // 따라서 Products provider에 있는 Product provider를 제공함.
                        return ChangeNotifierProvider.value(
                          value: products.products[idx],
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
