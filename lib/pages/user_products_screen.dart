import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../widgets/user_product.dart';
import '../widgets/app_drarwer.dart';
import '../pages/edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => UserProduct(
              id: productsData.items[index].id,
              title: productsData.items[index].title,
              imageURL: productsData.items[index].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
