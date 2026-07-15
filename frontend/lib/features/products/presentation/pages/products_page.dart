import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';

/// Pantalla que muestra la lista de productos.
///
/// Extiende `ConsumerWidget` (de Riverpod) en vez de `StatelessWidget`:
/// eso le da el `ref` para observar providers dentro de `build`.
class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el provider. Cuando el Future resuelve (o falla), Riverpod
    // vuelve a llamar build() solo. `productsAsync` es un AsyncValue.
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      // `.when` nos obliga a manejar los 3 estados. Nada de flags manuales.
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $error'),
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos todavía.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];
              return ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: Text(product.name),
                subtitle: Text(
                  '${product.brand ?? "Sin marca"} · ${product.unitOfMeasure.name}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
