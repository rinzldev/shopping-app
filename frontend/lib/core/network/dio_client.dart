import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// URL base de tu API FastAPI.
///
/// En web funciona `localhost` porque Chrome corre en tu misma máquina.
/// (Cuando pasemos a emulador Android esto cambia: el emulador ve tu PC
/// como 10.0.2.2, no localhost — lo resolveremos entonces.)
const String _baseUrl = 'http://localhost:8000/api/v1';

/// Provider que expone UNA instancia de Dio configurada, compartida por
/// toda la app. Cualquier código que necesite hacer HTTP la pide con
/// `ref.watch(dioProvider)` en vez de construir su propio Dio.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
});
