import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cart.dart';
import '../model/product.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final cartProducts = cart.products;
    double totalPrice = cartProducts.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Panier Flutter Sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Votre panier total est de",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${totalPrice.toStringAsFixed(2)}€",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Expanded(
              child: cartProducts.isEmpty
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Votre panier est actuellement vide"),
                  SizedBox(height: 10),
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 48,
                    color: Colors.black54,
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.network(product.image, fit: BoxFit.contain),
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(product.getPrice()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<Cart>().remove(product);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}