import '../data/constants.dart';
import '../models/product_data_model.dart';
import 'package:intl/intl.dart';

Map<String, List<Product>> groupProductsByCategory(List<Product> products) {
  Map<String, List<Product>> categorized = {};
  for (var cat in productCategories) {
    categorized[cat] = [];
  }
  for (var product in products) {
    if (categorized.containsKey(product.category)) {
      categorized[product.category]!.add(product);
    } else {
      categorized['Others'] = (categorized['Others'] ?? [])..add(product);
    }
  }
  return categorized;
}

String formatAmount(double amount) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return formatter.format(amount);
}
