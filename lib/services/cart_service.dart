// services/cart_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_data_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  static CartService get instance => _instance;

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Callback to notify UI of changes
  VoidCallback? _onCartChanged;

  void setCartChangeCallback(VoidCallback callback) {
    _onCartChanged = callback;
  }

  void _notifyChange() {
    _onCartChanged?.call();
  }

  // Add product to cart
  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Product already exists, increase quantity
      _cartItems[existingIndex].quantity++;
    } else {
      // Add new product to cart
      _cartItems.add(CartItem.fromProduct(product));
    }

    _saveCart();
    _notifyChange();
  }

  // Remove item from cart completely
  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    _saveCart();
    _notifyChange();
  }

  // Update item quantity
  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      _saveCart();
      _notifyChange();
    }
  }

  // Decrease quantity by 1
  void decreaseQuantity(String cartItemId) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      _saveCart();
      _notifyChange();
    }
  }

  // Clear entire cart
  void clearCart() {
    _cartItems.clear();
    _saveCart();
    _notifyChange();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        id: '',
        productId: '',
        name: '',
        description: '',
        price: 0,
        imageUrl: '',
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Save cart to local storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString('cart_items', jsonEncode(cartJson));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Load cart from local storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart_items');

      if (cartString != null) {
        final List<dynamic> cartJson = jsonDecode(cartString);
        _cartItems = cartJson.map((item) => CartItem.fromJson(item)).toList();
        _notifyChange();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
