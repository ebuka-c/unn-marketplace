import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/constants.dart';
import '../../models/product_data_model.dart';
import '../../services/auth_services.dart';
import '../../services/helpers.dart';
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

  late Map<String, List<Product>> categorizedProducts;

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  final auth = AuthService.instance;

  Future<void> _loadUserAndData() async {
    final user = auth.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = user.displayName ?? '';
      });
    }

    categorizedProducts = groupProductsByCategory(mockProducts);

    _tabController = TabController(
      length: productCategories.length,
      vsync: this,
    );

    setState(() {
      loading = false;
    });
  }

  void _logout() async {
    final auth = AuthService.instance;
    await auth
        .signOut(); // Add a signOut method in your AuthService if not present
    // After logout, navigate to login screen and clear navigation stack
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _navigateToFeature(String feature) {
    Navigator.pop(context); // Close drawer
    if (feature == 'Logout') {
      _logout();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $feature (to be implemented)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading || _tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
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
                              )
                            : Container(width: 60, color: Colors.grey.shade300),
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
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
