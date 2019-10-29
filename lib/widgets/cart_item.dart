import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String productId;
  final String id;
  final double price;
  final int qty;
  CartItem({
    this.id,
    this.productId,
    this.price,
    this.qty,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('YES'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('NO'),
                    )
                  ],
                  title: Text('Are You Sure'),
                  content: Text('Do You Want To Remove Item From The Cart?'),
                  elevation: 5.0,
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItems(productId);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              'Total Price :\$${(price * qty)}',
              style: TextStyle(fontSize: 10),
            ),
            trailing: Text('$qty X'),
          ),
        ),
      ),
    );
  }
}
