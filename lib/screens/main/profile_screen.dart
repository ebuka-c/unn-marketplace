// lib/screens/profile/profile_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unn_commerce/services/helpers.dart';
import 'package:unn_commerce/shared/app_snackbar.dart';

import '../../models/product_data_model.dart';
import '../../services/auth_services.dart';
import '../../data/constants.dart';
import '../../services/products_services.dart';
import '../../shared/confirm_delete_dialog.dart';

const String defaultProductImageUrl =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0LD1DPczqt74h8r0d2ct8dopvUh6me-C5eA&s';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = AuthService.instance;

  String userName = '';
  String userEmail = '';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameCtrl = TextEditingController();
  final TextEditingController _productDescriptionCtrl = TextEditingController();
  final TextEditingController _productAmountCtrl = TextEditingController();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // set default category to avoid validator failure
    if (productCategories.isNotEmpty) {
      _selectedCategory = productCategories.first;
    }

    // listen to product changes (ProductService must be a ChangeNotifier)
    ProductService.instance.addListener(_onProductsChanged);
  }

  Future<void> _loadUserData() async {
    final user = auth.currentUser;
    setState(() {
      userName = user?.displayName ?? '';
      userEmail = user?.email ?? '';
    });
  }

  @override
  void dispose() {
    ProductService.instance.removeListener(_onProductsChanged);
    _productNameCtrl.dispose();
    _productDescriptionCtrl.dispose();
    _productAmountCtrl.dispose();
    super.dispose();
  }

  void _onProductsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _productNameCtrl.text.trim(),
      description: _productDescriptionCtrl.text.trim(),
      category:
          _selectedCategory ??
          (productCategories.isNotEmpty
              ? productCategories.first
              : 'Uncategorized'),
      price: double.parse(_productAmountCtrl.text.trim()),
      imageUrl: defaultProductImageUrl,
    );

    await ProductService.instance.addProduct(newProduct);

    // Clear form
    _productNameCtrl.clear();
    _productDescriptionCtrl.clear();
    _productAmountCtrl.clear();
    setState(
      () => _selectedCategory = productCategories.isNotEmpty
          ? productCategories.first
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully!')),
    );
  }

  String? _validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter product amount';
    final price = double.tryParse(v.trim());
    if (price == null || price <= 0) return 'Enter valid amount > 0';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // compute products at build time so it reflects the latest state
    final products = ProductService.instance.products
        .where((p) => /* optional filter: only user's products */ true)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: $userName',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const Divider(height: 30, thickness: 2),
            const Text(
              'Create Product Listing',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _productNameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _productDescriptionCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter description'
                        : null,
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: productCategories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    value: _selectedCategory,
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Select category' : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _productAmountCtrl,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validatePrice,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Add Product',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 30, thickness: 2),

            const Text(
              'Your Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(width: 60, color: Colors.grey.shade300),
                        )
                      : Container(width: 60, color: Colors.grey.shade300),
                  title: Text(product.name),
                  tileColor: Colors.grey.shade100,
                  subtitle: Text(product.description),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₦${formatAmount(double.tryParse(product.price.toStringAsFixed(2)) ?? 0)}',
                      ),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => const ConfirmDeleteDialog(),
                          );

                          if (confirm == true) {
                            await ProductService.instance.removeProduct(
                              product,
                            );
                            appSnackBar(context, message: 'Product deleted');
                            if (mounted) setState(() {});
                          }
                        },
                        child: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
