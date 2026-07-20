import '../entities/product.dart';

/// Contrato (interfaz) del repositorio de productos.
///
/// Es una clase ABSTRACTA: define QUÉ operaciones existen, pero no CÓMO
/// se hacen. La implementación real vive en la capa `data`.
abstract interface class ProductRepository {
  /// Trae todos los productos del usuario.
  Future<List<Product>> getProducts();

  /// Crea un producto nuevo y devuelve el producto creado (ya con su `id`
  /// y timestamps asignados por el backend).
  ///
  /// Recibe solo los campos que el cliente puede definir: el `id`, `user_id`,
  /// `created_at` y `updated_at` los pone el servidor, nunca el cliente.
  Future<Product> createProduct({
    required String name,
    required UnitOfMeasure unitOfMeasure,
    String? brand,
    int? categoryId,
  });
}
