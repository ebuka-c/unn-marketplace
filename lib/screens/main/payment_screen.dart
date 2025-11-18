import 'package:flutter/material.dart';
import 'package:unn_commerce/services/helpers.dart';

class PaymentScreen extends StatefulWidget {
  final List<PaymentItem> items;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.items,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum PaymentMethod { card, transfer }

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout & Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Gateway Logos - replace with actual images or network logos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQd5cmdwOs2lqhgYXFFsNgbj-SowHmz5Owo-Q&s',
                  height: 15,
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Items Purchased',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                      '₦${formatAmount(double.tryParse((item.price * item.quantity).toStringAsFixed(2)) ?? 0)}',
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 2),

            Text(
              'Total: ₦${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 24),

            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Card Payment'),
              value: PaymentMethod.card,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Transfer'),
              value: PaymentMethod.transfer,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedMethod == null
                    ? null
                    : () {
                        // TODO: implement respective payment flow

                        if (_selectedMethod == PaymentMethod.card) {
                          // Navigate to card payment flow
                        } else {
                          // Navigate to transfer payment flow
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class to represent items in payment
class PaymentItem {
  final String name;
  final double price;
  final int quantity;

  PaymentItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
