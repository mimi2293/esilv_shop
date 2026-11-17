import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

/// Charge les produits depuis l'API UNE seule fois et les garde en mémoire.
/// (Remplace le FutureBuilder qui relançait la requête à chaque rebuild.)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final response =
  await http.get(Uri.parse("https://fakestoreapi.com/products"));

  if (response.statusCode != 200) {
    throw Exception("Erreur de connexion (${response.statusCode})");
  }

  final List<dynamic> productsJson = json.decode(response.body);
  return productsJson
      .map((product) => Product.fromMap(product as Map<String, dynamic>))
      .toList();
});