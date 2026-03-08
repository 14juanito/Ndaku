import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
        appBar: AppBar(title: const Text('Connexion')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                      final user = await context.read<AuthController>().login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (!context.mounted) return;
                      if (user == null) {
                        AppSnackbar.showError(
                          context,
                          controller.errorMessage ?? 'Connexion echouee.',
                        );
                      } else {
                        AppSnackbar.showSuccess(
                          context,
                          'Bienvenue ${user.email}',
                        );
                      }
                    },
                    child: const Text('Se connecter'),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final user = await context
                        .read<AuthController>()
                        .loginWithGoogle();
                    if (!context.mounted) return;
                    if (user == null) {
                      AppSnackbar.showError(
                        context,
                        controller.errorMessage ?? 'Connexion Google echouee.',
                      );
                    }
                  },
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Connexion Google'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text(
                    'Creer un compte',
                    style: TextStyle(color: AppColors.primary),
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
