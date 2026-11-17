import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(
    // ProviderScope : stocke tous les providers Riverpod (panier, produits)
    const ProviderScope(
      child: EsilvShop(),
    ),
  );
}