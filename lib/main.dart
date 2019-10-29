import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/product_overview_screen.dart';
import './models/cart.dart';
import './pages/product_detail_screen.dart';
import './models/products.dart';
import './pages/cart_sceen.dart';
import './models/order.dart';
import './pages/order_screen.dart';
import './pages/user_products_screen.dart';
import './pages/edit_products_screen.dart';
import './pages/auth-screen.dart';
import './models/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (context, auth, prevProducts) => Products(
              auth.getToken, prevProducts == null ? [] : prevProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Order(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) =>
                auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
