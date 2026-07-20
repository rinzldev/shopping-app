import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

/// Implementación concreta del contrato `ProductRepository` del dominio.
///
/// Su trabajo es orquestar las fuentes de datos. Hoy solo delega al data
/// source remoto, pero acá es DONDE viviría la lógica de: cache local,
/// mapear errores de Dio a errores del dominio, combinar remoto + local, etc.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> getProducts() {
    return _remoteDataSource.getProducts();
  }

  @override
  Future<Product> createProduct({
    required String name,
    required UnitOfMeasure unitOfMeasure,
    String? brand,
    int? categoryId,
  }) {
    return _remoteDataSource.createProduct(
      name: name,
      unitOfMeasure: unitOfMeasure,
      brand: brand,
      categoryId: categoryId,
    );
  }
}
