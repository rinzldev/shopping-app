import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: ShoppingApp()));
}

/// Ahora es `ConsumerWidget` (antes `StatelessWidget`): necesita `ref` para
/// leer el `routerProvider`.
class ShoppingApp extends ConsumerWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // MaterialApp.router (en vez de MaterialApp con `home:`) delega toda la
    // navegación a GoRouter.
    return MaterialApp.router(
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
