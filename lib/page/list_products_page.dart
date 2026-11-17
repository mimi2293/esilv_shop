import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import '../model/product.dart';
import '../model/cart.dart'; // Importe ton fichier cart.dart contenant le cartProvider

class ListProductsPage extends ConsumerWidget {
  final Function(Product) onAddToCart;

  const ListProductsPage({
    super.key,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le cartProvider pour récupérer la taille du panier pour le badge
    final cartProducts = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('E-Commerce'),
        actions: [
          IconButton(
            icon: Badge.count(
              child: const Icon(Icons.shopping_cart),
              count: cartProducts.length,
            ),
            onPressed: () {
              context.go('/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            final products = asyncSnapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                onTap: () {
                  context.go('/product/${products[index].id}', extra: products[index]);
                },
                title: Text(
                  products[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  products[index].getPrice(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Image.network(
                  products[index].image,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
                ),
                trailing: TextButton(
                  onPressed: () {
                    onAddToCart(products[index]);
                  },
                  child: Text("Ajouter".toUpperCase()),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    final response = await get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson
          .map((product) => Product.fromMap(product as Map<String, dynamic>))
          .toList();
    }
    return Future.error("Erreur de connexion");
  }
}