import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_panel.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = "order-screen";

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);
    final orders = orderProvider.orders;
    
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
            return SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {},
                children: orderProvider.orders.map((order) {
                  return ExpansionPanel(
                    headerBuilder: ((context, isExpanded) {
                      return ListTile(
                        title: Text(
                            "Order at: ${DateFormat.yMd().add_jm().format(order.orderDate)}"),
                      );
                    }),
                    body: Container(
                      height: 500,
                      child: ListView.builder(
                          itemCount: order.orderedItems.length,
                          itemBuilder: (context, index) {
                            final orderItem = order.orderedItems[index];
                            return ListTile(
                              title: Text(orderItem['title']),
                            );
                          }),
                    ),
                    isExpanded: order.expanded,
                    canTapOnHeader: true,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
