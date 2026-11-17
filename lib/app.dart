import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'model/product.dart';
import 'model/cart.dart';
import 'page/list_products_page.dart';
import 'page/cart_page.dart';
import 'page/detail_product_page.dart';

class EsilvShop extends StatefulWidget {
  const EsilvShop({super.key});

  @override
  State<EsilvShop> createState() => _EsilvShopState();
}

class _EsilvShopState extends State<EsilvShop> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ListProductsPage(
            onAddToCart: (product) => addToCart(context, product),
          ),
          routes: [
            GoRoute(
              path: 'product/:idProduct',
              builder: (context, state) {
                final idProductNullable = int.tryParse(
                  state.pathParameters['idProduct'] ?? "",
                );
                if (idProductNullable == null) {
                  return const Scaffold(
                    body: Center(child: Text("Produit introuvable")),
                  );
                }
                return FutureBuilder<Product>(
                  future: getProductById(idProductNullable),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
                      return DetailProductPage(
                        product: asyncSnapshot.data!,
                        onAddToCart: (product) => addToCart(context, product),
                      );
                    } else {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartPage(),
        ),
      ],
    );
  }

  Future<Product> getProductById(int? idProductNullable) async {
    final response = await get(
      Uri.parse('https://fakestoreapi.com/products/${idProductNullable!}'),
    );
    if (response.statusCode == 200) {
      return Product.fromMap(
        json.decode(response.body),
      );
    }
    return Future.error("Produit introuvable");
  }

  void addToCart(BuildContext context, Product product) {
    context.read<Cart>().add(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} ajouté au panier !'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Sales',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
    );
  }
}