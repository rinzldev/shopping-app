import 'package:dio/dio.dart';

import '../../domain/entities/product.dart';
import '../models/product_model.dart';

/// Contrato del data source remoto. Devuelve MODELOS (no entidades),
/// porque a este nivel todavía estamos en el mundo de los datos/JSON.
abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> createProduct({
    required String name,
    required UnitOfMeasure unitOfMeasure,
    String? brand,
    int? categoryId,
  });
}

/// Implementación: usa Dio para pegarle a la API y parsear la respuesta.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    // La baseUrl ya incluye /api/v1, así que solo pedimos el recurso.
    final response = await _dio.get<List<dynamic>>('/products');

    // Si data viene null, usamos lista vacía (operador ??).
    final data = response.data ?? [];

    // Convertimos cada elemento JSON del array en un ProductModel.
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> createProduct({
    required String name,
    required UnitOfMeasure unitOfMeasure,
    String? brand,
    int? categoryId,
  }) async {
    // POST /products con el body que espera tu ProductCreate del backend.
    // Armamos el JSON acá porque todavía no existe un producto (no hay id).
    final response = await _dio.post<Map<String, dynamic>>(
      '/products',
      data: {
        'name': name,
        'brand': brand,
        'category_id': categoryId,
        'unit_of_measure': unitOfMeasure.name,
      },
    );

    // La API responde con el producto creado (ya con id y timestamps).
    return ProductModel.fromJson(response.data!);
  }
}
