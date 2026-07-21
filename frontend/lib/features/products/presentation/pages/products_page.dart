import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';

/// Pantalla que muestra la lista de productos.
class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      // Botón flotante para ir al formulario de creación.
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new'),
        child: const Icon(Icons.add),
      ),
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
