// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/constants.dart';
import '../../models/product_data_model.dart';
import '../../services/auth_services.dart';
import '../../services/cart_service.dart';
import '../../services/helpers.dart';
import '../../services/products_services.dart';
import '../../shared/app_snackbar.dart';
import 'product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String userName = '';
  bool loading = true;

  // categorizedProducts keyed by category name
  late Map<String, List<Product>> categorizedProducts;

  final auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    // Listen to product changes so UI updates automatically
    ProductService.instance.addListener(_onProductsChanged);
    _loadUserAndData();
  }

  Future<void> _loadUserAndData() async {
    // Load user display name
    final user = auth.currentUser;
    if (user != null) {
      userName = user.displayName ?? '';
    }

    // Initialize categorizedProducts from ProductService
    categorizedProducts = groupProductsByCategory(
      ProductService.instance.products,
    );

    // Ensure TabController is created after we know the categories
    _tabController = TabController(
      length: productCategories.length,
      vsync: this,
    );

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void _onProductsChanged() {
    // Re-categorize products when ProductService notifies
    if (!mounted) return;
    setState(() {
      categorizedProducts = groupProductsByCategory(
        ProductService.instance.products,
      );
    });
  }

  void _logout() async {
    final auth = AuthService.instance;
    await auth.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
    }
  }

  void _navigateToFeature(String feature) {
    Navigator.pop(context); // close drawer
    if (feature == 'Logout') {
      _logout();
      return;
    }
    if (feature == 'Cart') {
      Navigator.pushNamed(context, '/cart');
      return;
    }
    if (feature == 'Profile') {
      Navigator.pushNamed(context, '/profile');
      return;
    }
    appSnackBar(context, message: 'Navigate to $feature (to be implemented)');
  }

  @override
  void dispose() {
    ProductService.instance.removeListener(_onProductsChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading || _tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (CartService.instance.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${CartService.instance.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: productCategories.map((cat) => Tab(text: cat)).toList(),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => _navigateToFeature('Profile'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () => _navigateToFeature('Cart'),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Checkout / Place Order'),
              onTap: () => _navigateToFeature('Checkout / Place Order'),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Orders (Buyer)'),
              onTap: () => _navigateToFeature('Orders (Buyer)'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Seller Inventory + Orders'),
              onTap: () => _navigateToFeature('Seller Inventory + Orders'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _navigateToFeature('Logout'),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(
              'Welcome $userName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: productCategories.map((category) {
                final products = categorizedProducts[category] ?? [];
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products in this category'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 60,
                                      color: Colors.grey.shade300,
                                    ),
                              )
                            : Container(width: 60, color: Colors.grey.shade300),
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Text(
                          '₦${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
