import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/property_card.dart';

class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final allProperties = context.watch<PropertyController>().properties;
    final myProperties = allProperties
        .where((item) => item.ownerId == session.currentUser?.id)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Listings')),
      body: myProperties.isEmpty
          ? Center(
              child: Text(
                'Your published properties will appear here.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(22),
              itemBuilder: (context, index) =>
                  PropertyCard(property: myProperties[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: myProperties.length,
            ),
    );
  }
}
