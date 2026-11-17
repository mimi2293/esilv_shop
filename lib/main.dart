import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/cart.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const EsilvShop(),
    ),
  );
}