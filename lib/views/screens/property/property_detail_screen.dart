import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../models/property.dart';
import '../../widgets/property_card.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context) {
    final propertyController = context.watch<PropertyController>();
    final favoritesController = context.watch<FavoritesController>();
    final property = _findById(propertyController.properties, propertyId);
    if (property == null) {
      return const Scaffold(body: Center(child: Text('Bien introuvable.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Details du bien')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyCard(property: property),
            const SizedBox(height: 16),
            Text(property.description),
            const SizedBox(height: 8),
            Text('Adresse: ${property.address}'),
            const SizedBox(height: 8),
            Text('Coordonnees: ${property.latitude}, ${property.longitude}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => favoritesController.toggleFavorite(property.id),
              icon: Icon(
                favoritesController.isFavorite(property.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: const Text('Favori'),
            ),
          ],
        ),
      ),
    );
  }

  Property? _findById(List<Property> list, String id) {
    try {
      return list.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
