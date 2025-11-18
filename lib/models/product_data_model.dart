class Product {
  final String id;
  final String name;
  final String description;
  final String category; // One of your categories
  final double price;
  final String imageUrl; // optional

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}
