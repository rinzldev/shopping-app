import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/products/presentation/pages/products_page.dart';

void main() {
  // ProviderScope es la raíz de Riverpod: guarda el estado de TODOS los
  // providers. Toda la app debe vivir dentro de él.
  runApp(const ProviderScope(child: ShoppingApp()));
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProductsPage(),
    );
  }
}
