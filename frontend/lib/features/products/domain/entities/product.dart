/// La unidad de medida de un producto.
///
/// Es un conjunto CERRADO de valores (igual que en el backend), así que
/// lo modelamos como enum en vez de String: el compilador te obliga a
/// manejar solo valores válidos y evita typos.
enum UnitOfMeasure { unit, kg, g, l, ml, pack }

/// Entidad de dominio: representa un Producto en el corazón de la app.
///
/// Es pura: no sabe nada de JSON, ni de HTTP, ni de Flutter. Solo describe
/// QUÉ es un producto. Es `immutable` (todos los campos `final`): una vez
/// creado no cambia, lo que evita bugs de estado compartido.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.unitOfMeasure,
    this.brand,
    this.categoryId,
  });

  final int id;
  final String name;
  final UnitOfMeasure unitOfMeasure;

  /// Nullable (`String?`): en el backend `brand` puede ser null.
  final String? brand;

  /// Nullable: un producto puede no tener categoría.
  final int? categoryId;
}
