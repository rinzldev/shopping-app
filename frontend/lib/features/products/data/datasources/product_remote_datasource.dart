import 'package:dio/dio.dart';

import '../models/product_model.dart';

/// Contrato del data source remoto. Devuelve MODELOS (no entidades),
/// porque a este nivel todavía estamos en el mundo de los datos/JSON.
abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
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
}
