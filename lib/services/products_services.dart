import '../models/product_data_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final List<Product> _products = [...mockProducts];

  List<Product> get products => List.unmodifiable(_products);

  void addProduct(Product p) {
    _products.add(p);
  }

  void removeProduct(Product p) {
    _products.removeWhere((prod) => prod.id == p.id);
  }
}
