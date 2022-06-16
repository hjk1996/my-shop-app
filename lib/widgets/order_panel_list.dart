import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

// ExpansionPanelList를 사용할 때는 StatefulWidget으로 감싸주자.
class OrderPanelList extends StatefulWidget {
  const OrderPanelList({
    Key? key,
    required this.orderProvider,
  }) : super(key: key);

  final Orders orderProvider;

  @override
  State<OrderPanelList> createState() => _OrderPanelListState();
}

class _OrderPanelListState extends State<OrderPanelList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        dividerColor: Colors.blueGrey,
        
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            widget.orderProvider.orders[panelIndex].expanded = !isExpanded;
          });
        },
        children: widget.orderProvider.orders.map((order) {
          return ExpansionPanel(
            headerBuilder: ((context, isExpanded) {
              return ListTile(
                title: Text(
                    "Order at: ${DateFormat.yMd().add_jm().format(order.orderDate)}"),
                trailing: Chip(
                    label: Text("${order.totalPrice}\$"),
                    backgroundColor: Colors.amber),
              );
            }),
            body: Container(
              height: 150,
              child: ListView.builder(
                  itemCount: order.orderedItems.length,
                  itemBuilder: (context, index) {
                    final orderItem = order.orderedItems[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(orderItem['imageUrl'])),
                      title: Text(orderItem['title']),
                      subtitle: Text("Quantity: ${orderItem['quantity']}"),
                      trailing: Text(
                          "${orderItem['price'] * orderItem['quantity']}\$"),
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
}
