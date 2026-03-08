import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../widgets/app_snackbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final auth = context.watch<AuthController>();
    final user = session.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user?.email ?? '-'}'),
            const SizedBox(height: 8),
            Text('Nom: ${user?.fullName ?? '-'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.logout();
                if (!context.mounted) return;
                if (auth.errorMessage != null) {
                  AppSnackbar.showError(context, auth.errorMessage!);
                } else {
                  AppSnackbar.showSuccess(context, 'Deconnexion reussie.');
                }
              },
              child: const Text('Se deconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
