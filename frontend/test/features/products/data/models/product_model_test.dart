import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_app/features/products/data/models/product_model.dart';
import 'package:shopping_app/features/products/domain/entities/product.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('convierte un JSON completo del backend', () {
      // Arrange: el JSON tal cual lo manda la API.
      final json = {
        'id': 1,
        'name': 'Leche',
        'brand': 'La Serenísima',
        'category_id': 3,
        'unit_of_measure': 'l',
      };

      // Act
      final model = ProductModel.fromJson(json);

      // Assert
      expect(model.id, 1);
      expect(model.name, 'Leche');
      expect(model.brand, 'La Serenísima');
      expect(model.categoryId, 3);
      expect(model.unitOfMeasure, UnitOfMeasure.l);
    });

    test('acepta brand y category_id nulos', () {
      final Map<String, dynamic> json = {
        'id': 7,
        'name': 'Arroz',
        'brand': null,
        'category_id': null,
        'unit_of_measure': 'kg',
      };

      final model = ProductModel.fromJson(json);

      expect(model.brand, isNull);
      expect(model.categoryId, isNull);
      expect(model.unitOfMeasure, UnitOfMeasure.kg);
    });

    test('lanza si unit_of_measure no es un valor conocido', () {
      final Map<String, dynamic> json = {
        'id': 9,
        'name': 'Misterio',
        'brand': null,
        'category_id': null,
        'unit_of_measure': 'litros',
      };

      expect(() => ProductModel.fromJson(json), throwsArgumentError);
    });
  });

  group('ProductModel.toJson', () {
    test('serializa el producto sin incluir el id', () {
      const model = ProductModel(
        id: 5,
        name: 'Leche',
        unitOfMeasure: UnitOfMeasure.l,
        brand: 'La Serenísima',
        categoryId: 3,
      );

      final json = model.toJson();

      expect(json, {
        'name': 'Leche',
        'brand': 'La Serenísima',
        'category_id': 3,
        'unit_of_measure': 'l',
      });
      expect(json.containsKey('id'), isFalse);
    });
  });
}
