import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../models/property_filter.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyController>().startWatching();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final propertyController = context.watch<PropertyController>();
    final favoritesController = context.watch<FavoritesController>();
    final items = propertyController.properties;

    return LoadingOverlay(
      isLoading: propertyController.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biens immobiliers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.map_outlined, color: AppColors.primary),
              onPressed: () => context.push(AppRoutes.map),
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite_outline,
                color: AppColors.primary,
              ),
              onPressed: () => context.push(AppRoutes.favorites),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () => context.push(AppRoutes.newProperty),
          label: const Text('Ajouter'),
          icon: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Bienvenue ${session.currentUser?.fullName ?? session.currentUser?.email ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => FilterBottomSheet(
                          initialFilter: propertyController.filter,
                        ),
                      );
                      if (result is PropertyFilter) {
                        propertyController.applyFilter(result);
                      }
                    },
                    icon: const Icon(Icons.tune, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Aucun bien pour le moment.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final property = items[index];
                        return PropertyCard(
                          property: property,
                          onTap: () => context.push(
                            '${AppRoutes.propertyDetail}/${property.id}',
                          ),
                          trailing: IconButton(
                            onPressed: () =>
                                favoritesController.toggleFavorite(property.id),
                            icon: Icon(
                              favoritesController.isFavorite(property.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: items.length,
                    ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomNav(
          onHome: () {},
          onMyProperties: () => context.push(AppRoutes.myProperties),
          onProfile: () => context.push(AppRoutes.profile),
          onMap: () => context.push(AppRoutes.map),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.onHome,
    required this.onMyProperties,
    required this.onProfile,
    required this.onMap,
  });

  final VoidCallback onHome;
  final VoidCallback onMyProperties;
  final VoidCallback onProfile;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.charcoal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: onHome,
            icon: const Icon(Icons.home, color: AppColors.primary),
          ),
          IconButton(
            onPressed: onMap,
            icon: const Icon(Icons.map_outlined, color: AppColors.white),
          ),
          IconButton(
            onPressed: onMyProperties,
            icon: const Icon(Icons.business_outlined, color: AppColors.white),
          ),
          IconButton(
            onPressed: onProfile,
            icon: const Icon(Icons.person_outline, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
