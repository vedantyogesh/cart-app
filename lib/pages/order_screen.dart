import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/app_drarwer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchOrders(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('AN ERROR!!!!!!!'),
              );
            } else {
              return Consumer<Order>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) =>
                      OrderItem(orderData.orders[index]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
