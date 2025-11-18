// services/product_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_data_model.dart';
import '../data/constants.dart';

class ProductService extends ChangeNotifier {
  ProductService._internal() {
    _init();
  }
  static final ProductService instance = ProductService._internal();

  final List<Product> _products = [...mockProducts];

  List<Product> get products => List.unmodifiable(_products);

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('user_products') ?? [];
    final userProducts = productsJson
        .map((p) => Product.fromJson(json.decode(p) as Map<String, dynamic>))
        .toList();

    // Avoid duplicates (by id) — only add if id not present
    for (final p in userProducts) {
      if (!_products.any((x) => x.id == p.id)) _products.add(p);
    }

    notifyListeners();
  }

  Future<void> _saveUserProducts() async {
    final prefs = await SharedPreferences.getInstance();
    // Persist only user-added products (not mockProducts) — decide by your app's logic.
    // Here we persist all products (you can change to filter).
    final productsJson = _products.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList('user_products', productsJson);
  }

  Future<void> addProduct(Product p) async {
    _products.add(p);
    await _saveUserProducts();
    notifyListeners();
  }

  Future<void> removeProduct(Product p) async {
    _products.removeWhere((prod) => prod.id == p.id);
    await _saveUserProducts();
    notifyListeners();
  }

  // Optional helper if you want to completely replace product list
  Future<void> setProducts(List<Product> list) async {
    _products
      ..clear()
      ..addAll(list);
    await _saveUserProducts();
    notifyListeners();
  }
}
