import 'package:esilv_shop/model/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart.g.dart';

// keepAlive: true → le panier n'est jamais vidé automatiquement,
// même si aucune page ne l'écoute à un instant donné.
@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  List<Product> build() {
    return []; // panier vide au départ
  }

  void add(Product product) {
    // Nouvelle liste (immutabilité) → Riverpod détecte le changement
    state = [...state, product];
  }

  void remove(Product product) {
    // Retire UN seul exemplaire du produit (pas tous)
    final index = state.indexWhere((p) => p.id == product.id);
    if (index == -1) return;
    state = [...state]..removeAt(index);
  }

  // Total du panier.
  // fold<num> : on part de 0 et on additionne chaque prix.
  // Pas de "/ 100" : les prix de l'API sont déjà en euros (ex : 109.95).
  String get priceInEuros =>
      "${state.fold<num>(0, (prv, actual) => prv + actual.price).toStringAsFixed(2)}€";
}