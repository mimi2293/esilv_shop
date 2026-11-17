import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cart.dart';
import '../model/product.dart';

class DetailProductPage extends ConsumerWidget {
  final Product product;

  const DetailProductPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On surveille le panier pour savoir si ce produit y est déjà
    final cartProducts = ref.watch(cartProvider);
    final isInCart = cartProducts.any((p) => p.id == product.id);
    final rate = product.rating.rate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          product.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: SizedBox(
                height: 250,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Note : étoiles + "3.9/5"
            Row(
              children: [
                for (int i = 1; i <= 5; i++)
                  Icon(
                    rate >= i
                        ? Icons.star
                        : (rate >= i - 0.5
                        ? Icons.star_half
                        : Icons.star_border),
                    color: Colors.amber,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                Text("$rate/5"),
                const SizedBox(width: 4),
                Text(
                  "(${product.rating.count} avis)",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Titre + prix sur la même ligne
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  product.getPrice(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Catégorie + "Dans le panier"
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(product.category.toUpperCase())),
                if (isInCart)
                  const Chip(
                    label: Text("Dans le panier"),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              product.description,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 30),

            // Bouton Ajouter
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} ajouté au panier !'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text("Ajouter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}