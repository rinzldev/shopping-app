import '../entities/product.dart';

/// Contrato (interfaz) del repositorio de productos.
///
/// Es una clase ABSTRACTA: define QUÉ operaciones existen, pero no CÓMO
/// se hacen. La implementación real vive en la capa `data`.
///
/// ¿Por qué una interfaz? Para invertir la dependencia: la capa de
/// presentación depende de esta abstracción, no de Dio ni de la API.
/// Mañana podés cambiar la implementación (API, cache, mock para tests)
/// sin tocar el resto de la app.
abstract interface class ProductRepository {
  /// Trae todos los productos del usuario.
  ///
  /// Devuelve un `Future` porque es una operación asíncrona (va a la red).
  Future<List<Product>> getProducts();
}
