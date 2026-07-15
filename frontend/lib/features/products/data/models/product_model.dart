import '../../domain/entities/product.dart';

/// Modelo de datos: es un `Product` que ADEMÁS sabe convertirse desde/hacia
/// JSON. Vive en la capa `data` porque el JSON es un detalle de infraestructura,
/// no del negocio.
///
/// Extiende `Product` (`extends`), así que un `ProductModel` ES un `Product`:
/// una `List<ProductModel>` se puede usar donde se espera `List<Product>`.
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.unitOfMeasure,
    super.brand,
    super.categoryId,
  });

  /// Construye un ProductModel desde el mapa JSON que devuelve la API.
  ///
  /// Es un `factory`: un constructor que puede hacer lógica antes de crear
  /// la instancia (acá, traducir campos).
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      // El backend manda "l", "kg", etc. — que coinciden EXACTO con los
      // nombres del enum. `byName` hace la conversión string → enum.
      unitOfMeasure: UnitOfMeasure.values.byName(
        json['unit_of_measure'] as String,
      ),
      // `as String?` permite que sea null sin romper.
      brand: json['brand'] as String?,
      categoryId: json['category_id'] as int?,
    );
  }

  /// Convierte el objeto de vuelta a JSON (lo usaremos al crear productos).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'category_id': categoryId,
      // `.name` devuelve el string del enum: UnitOfMeasure.l → "l".
      'unit_of_measure': unitOfMeasure.name,
    };
  }
}
