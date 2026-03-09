import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesController>().favorites;
    final properties = context.watch<PropertyController>().properties;
    final favoriteIds = favorites.map((fav) => fav.propertyId).toSet();
    final favoriteProperties = properties
        .where((property) => favoriteIds.contains(property.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Favorites')),
      body: favoriteProperties.isEmpty
          ? Center(
              child: Text(
                'No favorite property yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(22),
              itemBuilder: (context, index) {
                final item = favoriteProperties[index];
                return PropertyCard(
                  property: item,
                  onTap: () =>
                      context.push('${AppRoutes.propertyDetail}/${item.id}'),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: favoriteProperties.length,
            ),
    );
  }
}
