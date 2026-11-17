import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cart.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).priceInEuros;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Panier Esilv Shop'),
      ),
      body: Column(
        children: [
          // Total en haut du panier
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Votre panier total est de"),
                Text(
                  total,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Contenu du panier (Expanded car ListView dans une Column)
          Expanded(
            child: cartProducts.isEmpty
                ? const Center(
              child: Text(
                'Votre panier est vide',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    product.getPrice(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        ref.read(cartProvider.notifier).remove(product),
                    child: const Text("RETIRER"),
                  ),
                );
              },
            ),
          ),

          // Bouton Commander
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: cartProducts.isEmpty
                    ? null // désactivé si panier vide
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Commande envoyée !")),
                  );
                },
                child: const Text("Commander"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}