import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../pages/edit_products_screen.dart';

class UserProduct extends StatelessWidget {
  final String imageURL;
  final String id;
  final String title;
  UserProduct({
    this.id,
    this.imageURL,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
