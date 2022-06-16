import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_panel_list.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = "order-screen";

  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: orderProvider.fetchOrdersFromServer(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // TO-DO:: 펼칠 수 있는 오더 리스트뷰 만들기.
            return OrderPanelList(orderProvider: orderProvider);
          }
        },
      ),
    );
  }
}
