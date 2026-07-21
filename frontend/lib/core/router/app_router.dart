import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/products_page.dart';

/// Provee el router de la app. Lo exponemos como provider (en vez de una
/// variable global) para que, más adelante, la navegación pueda reaccionar
/// a estado — por ejemplo, redirigir al login si no hay sesión.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsPage(),
        routes: [
          // Ruta ANIDADA: al ser hija de '/', su ruta completa es '/new'.
          // Anidarla hace que "volver" (pop) regrese a la lista de forma natural.
          GoRoute(
            path: 'new',
            builder: (context, state) => const ProductFormPage(),
          ),
        ],
      ),
    ],
  );
});
