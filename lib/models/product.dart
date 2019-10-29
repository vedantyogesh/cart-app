import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> isFavoriteSelector() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final String url = 'https://muntest-15294.firebaseio.com/products/$id.json';
    try {
      final res = await http.patch(
        url,
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}
