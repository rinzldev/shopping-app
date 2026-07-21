import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

/// Eslabón 1: provee el DataSource, inyectándole el Dio del dioProvider.
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
});

/// Eslabón 2: provee el Repositorio, inyectándole el DataSource.
/// El TIPO expuesto es la interfaz del dominio (ProductRepository), NO la
/// implementación: el resto de la app depende de la abstracción, no del detalle.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});

/// Eslabón 3: el provider que consumirá la UI. Dispara getProducts() y
/// expone el resultado como un AsyncValue (cargando / datos / error).
final productsProvider = FutureProvider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});
