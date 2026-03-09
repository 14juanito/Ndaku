import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../models/property.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/soft_card.dart';

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

    final details = [
      _DetailMetric(
        icon: Icons.bed_outlined,
        value: (property.rooms ?? 0).toString(),
        label: 'Bedrooms',
      ),
      _DetailMetric(
        icon: Icons.bathtub_outlined,
        value: (property.bathrooms ?? 0).toString(),
        label: 'Bathrooms',
      ),
      _DetailMetric(
        icon: Icons.straighten_rounded,
        value: property.surfaceM2?.toStringAsFixed(0) ?? '0',
        label: 'Area in sqft',
      ),
      _DetailMetric(
        icon: Icons.calendar_today_outlined,
        value: (property.builtYear ?? 0).toString(),
        label: 'Built in',
      ),
      _DetailMetric(
        icon: Icons.weekend_outlined,
        value: (property.livingRooms ?? 0).toString(),
        label: 'Living Room',
      ),
      _DetailMetric(
        icon: Icons.directions_car_outlined,
        value: (property.parkingSpots ?? 0).toString(),
        label: 'Cars Parking',
      ),
    ];
    final priceLine = property.listingLabel == 'Rent'
        ? 'Rent \$${property.price.toStringAsFixed(0)} ${property.priceSuffix ?? '/ Month'}'
        : '${property.listingLabel ?? 'Sale'} \$${property.price.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 310,
                  child: AppNetworkImage(
                    imageUrl: property.heroImage,
                    borderRadius: 34,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black.withValues(alpha: 0.50),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: _CircleAction(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: _CircleAction(
                    icon: favoritesController.isFavorite(property.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    onTap: () =>
                        favoritesController.toggleFavorite(property.id),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      priceLine,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${property.commune}, ${property.city}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.rating?.toStringAsFixed(1) ?? '4.8',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: 'Photos',
              actionLabel: 'See all',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 82,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: property.images.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return AppNetworkImage(
                    imageUrl: property.images[index],
                    height: 82,
                    width: 82,
                    borderRadius: 22,
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Property Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              itemCount: details.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.98,
              ),
              itemBuilder: (context, index) {
                final item = details[index];
                return SoftCard(
                  padding: const EdgeInsets.all(14),
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.icon, color: AppColors.blueGray, size: 20),
                      const Spacer(),
                      Text(
                        item.value,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            Text(
              property.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.push('${AppRoutes.map}?propertyId=${property.id}'),
              child: const Text('Location & Reviews'),
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

class _DetailMetric {
  const _DetailMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.blueGray,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
