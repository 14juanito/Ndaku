import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../widgets/property_card.dart';

class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final all = context.watch<PropertyController>().properties;
    final mine = all
        .where((item) => item.ownerId == session.currentUser?.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes annonces')),
      body: mine.isEmpty
          ? const Center(child: Text('Aucune annonce publiee.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) =>
                  PropertyCard(property: mine[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: mine.length,
            ),
    );
  }
}
