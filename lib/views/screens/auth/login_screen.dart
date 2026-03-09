import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/soft_card.dart';

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
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
            children: [
              const Center(child: AppLogo(size: 88)),
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to browse curated homes, save favorites, and manage your listings.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SoftCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: Validators.email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        validator: Validators.password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            final user = await context
                                .read<AuthController>()
                                .login(
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
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final user = await context
                                .read<AuthController>()
                                .loginWithGoogle();
                            if (!context.mounted) return;
                            if (user == null) {
                              AppSnackbar.showError(
                                context,
                                controller.errorMessage ??
                                    'Connexion Google echouee.',
                              );
                            }
                          },
                          icon: const Icon(Icons.account_circle_outlined),
                          label: const Text('Connexion Google'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => context.push(AppRoutes.register),
                child: const Text(
                  'Creer un compte',
                  style: TextStyle(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
