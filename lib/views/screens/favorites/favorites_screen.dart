import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesController>().favorites;
    final properties = context.watch<PropertyController>().properties;
    final favoritePropertyIds = favorites.map((fav) => fav.propertyId).toSet();
    final favoriteProperties = properties
        .where((p) => favoritePropertyIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: favoriteProperties.isEmpty
          ? const Center(child: Text('Aucun favori pour le moment.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
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
