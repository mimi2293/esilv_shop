import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/cart.dart';
import '../model/product.dart';
import '../model/products_provider.dart';

class ListProductsPage extends ConsumerWidget {
  const ListProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch → la page se redessine quand le panier change (badge)
    final cartProducts = ref.watch(cartProvider);
    // watch → état du chargement des produits (loading / error / data)
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('E-Commerce'),
        actions: [
          IconButton(
            icon: Badge.count(
              count: cartProducts.length,
              isLabelVisible: cartProducts.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text("Erreur : $error"),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(productsProvider),
                child: const Text("Réessayer"),
              ),
            ],
          ),
        ),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final Product product = products[index];
            return ListTile(
              onTap: () => context.go('/product/${product.id}', extra: product),
              leading: Image.network(
                product.image,
                width: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported),
              ),
              title: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                product.getPrice(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: TextButton(
                onPressed: () {
                  // read → on agit une fois (pas besoin de surveiller)
                  ref.read(cartProvider.notifier).add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} ajouté !'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text("AJOUTER"),
              ),
            );
          },
        ),
      ),
    );
  }
}