import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    return LoadingOverlay(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Inscription')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Center(child: AppLogo(size: 84, showLabel: false)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Nom'),
                  decoration: const InputDecoration(labelText: 'Nom complet'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  validator: Validators.email,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  validator: Validators.password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final user = await context
                          .read<AuthController>()
                          .register(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            fullName: _nameController.text.trim(),
                          );
                      if (!context.mounted) return;
                      if (user == null) {
                        AppSnackbar.showError(
                          context,
                          controller.errorMessage ?? 'Inscription echouee.',
                        );
                      } else {
                        AppSnackbar.showSuccess(context, 'Compte cree.');
                      }
                    },
                    child: const Text('Creer mon compte'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
