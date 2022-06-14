import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/products.dart';
import './providers/product.dart';

import './screens/auth_screeen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';

import './providers/product.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Auth>(
        create: (context) => Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null, null),
          update: (ctx, auth, prev) {
            return Products(auth.userId, auth.token);
          }),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) => FutureBuilder(
          future: auth.loadAuthDataFromLocal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
                routes: {
                  ProductDetailScreen.routeName: (context) =>
                      ProductDetailScreen(),
                  CartScreen.routeName: (context) => CartScreen()
                },
              );
            }
          }),
    );
  }
}
