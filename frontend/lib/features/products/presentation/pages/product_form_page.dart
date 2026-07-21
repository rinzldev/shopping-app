import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';

/// Formulario para crear un producto.
///
/// Es un `ConsumerStatefulWidget`: "Stateful" porque tiene estado que cambia
/// mientras el usuario escribe (el texto, la unidad elegida, si está enviando);
/// "Consumer" porque además necesita `ref` para hablar con los providers.
class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  // Llave que identifica al Form, para poder validarlo desde el código.
  final _formKey = GlobalKey<FormState>();

  // Controllers: leen y controlan el texto de cada campo.
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();

  // Estado local del formulario.
  UnitOfMeasure _unit = UnitOfMeasure.unit;
  bool _isSubmitting = false;

  @override
  void dispose() {
    // Liberamos los controllers al destruir la pantalla (evita fugas de memoria).
    _nameController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 1. Valida todos los campos. Si alguno falla, muestra el error y corta.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // 2. Llama al repositorio (vía ref.read, porque es una acción puntual).
      await ref
          .read(productRepositoryProvider)
          .createProduct(
            name: _nameController.text.trim(),
            unitOfMeasure: _unit,
            brand: _brandController.text.trim().isEmpty
                ? null
                : _brandController.text.trim(),
          );

      // 3. Invalida la lista para que se vuelva a pedir con el nuevo producto.
      ref.invalidate(productsProvider);

      // 4. Vuelve a la pantalla anterior (la lista).
      if (mounted) context.pop();
    } catch (e) {
      // Si el POST falla, mostramos un aviso y reactivamos el botón.
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Marca (opcional)',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UnitOfMeasure>(
                  initialValue: _unit,
                  decoration: const InputDecoration(labelText: 'Unidad'),
                  items: UnitOfMeasure.values
                      .map(
                        (u) => DropdownMenuItem(value: u, child: Text(u.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _unit = value);
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
