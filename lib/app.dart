import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esilv_shop/model/product.dart';
import 'package:esilv_shop/page/list_products_page.dart';
import 'package:esilv_shop/page/detail_product_page.dart';
import 'package:esilv_shop/page/cart_page.dart';

// Routeur déclaré UNE seule fois, en dehors de build().
// Les routes 'product/:id' et 'cart' sont IMBRIQUÉES sous '/'
// → la page Liste reste en dessous → flèche retour automatique.
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ListProductsPage(),
      routes: [
        GoRoute(
          path: 'product/:id',
          builder: (context, state) {
            final product = state.extra as Product;
            return DetailProductPage(product: product);
          },
        ),
        GoRoute(
          path: 'cart',
          builder: (context, state) => const CartPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page introuvable')),
  ),
);

class EsilvShop extends StatelessWidget {
  const EsilvShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ESILV Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}