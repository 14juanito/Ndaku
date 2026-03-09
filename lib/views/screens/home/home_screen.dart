import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/favorites_controller.dart';
import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/app_router.dart';
import '../../../models/property.dart';
import '../../../models/property_filter.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/soft_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = ['House', 'Office', 'Apartment'];

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'House';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyController>().startWatching();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final propertyController = context.watch<PropertyController>();
    final favoritesController = context.watch<FavoritesController>();

    final properties = propertyController.properties;
    final filtered = properties.where((property) {
      final matchesCategory =
          property.type.toLowerCase() == _selectedCategory.toLowerCase();
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          '${property.title} ${property.subtitle ?? ''} ${property.address} ${property.commune}'
              .toLowerCase()
              .contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    final showcase = filtered.isEmpty ? properties.take(3).toList() : filtered;
    final featured = showcase.take(3).toList();
    final nearby = showcase.length > 1
        ? showcase.skip(1).take(3).toList()
        : showcase;
    final avatarLabel = session.currentUser?.fullName?.trim().isNotEmpty == true
        ? session.currentUser!.fullName!.trim().substring(0, 1).toUpperCase()
        : (session.currentUser?.email.isNotEmpty == true
              ? session.currentUser!.email.substring(0, 1).toUpperCase()
              : 'N');

    return LoadingOverlay(
      isLoading: propertyController.isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: _BottomFloatNav(
          onExplore: () => context.push(_mapRouteFor(featured.firstOrNull)),
          onFavorite: () => context.push(AppRoutes.favorites),
          onMessage: () => context.push(AppRoutes.profile),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        _TopActionButton(
                          icon: Icons.menu_rounded,
                          onTap: () => _showQuickMenu(context),
                        ),
                        const Spacer(),
                        _TopActionButton(
                          icon: Icons.notifications_none_rounded,
                          iconColor: AppColors.blueGray,
                          onTap: () {
                            AppSnackbar.showSuccess(
                              context,
                              'Aucune nouvelle notification pour le moment.',
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _AvatarBubble(label: avatarLabel),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Discover\nyour new house!',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(height: 1.02, letterSpacing: -0.8),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 22,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search Places',
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: AppColors.blueGray,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _TopActionButton(
                          icon: Icons.tune_rounded,
                          filled: true,
                          onTap: () async {
                            final result =
                                await showModalBottomSheet<PropertyFilter>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => FilterBottomSheet(
                                    initialFilter: propertyController.filter,
                                  ),
                                );
                            if (!context.mounted) return;
                            if (result != null) {
                              context.read<PropertyController>().applyFilter(
                                result,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return _CategoryPill(
                            label: category,
                            selected: category == _selectedCategory,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 252,
                      child: featured.isEmpty
                          ? const _PolishedEmptyState(
                              title: 'No curated spaces yet',
                              subtitle:
                                  'Create a listing or switch category to preview the premium layout.',
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: featured.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final property = featured[index];
                                return _FeaturedPropertyCard(
                                  property: property,
                                  isFavorite: favoritesController.isFavorite(
                                    property.id,
                                  ),
                                  onTap: () => context.push(
                                    '${AppRoutes.propertyDetail}/${property.id}',
                                  ),
                                  onFavorite: () => favoritesController
                                      .toggleFavorite(property.id),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 28),
                    _SectionHeader(
                      title: 'Property Nearby',
                      actionLabel: 'See all',
                      onTap: () => context.push(AppRoutes.favorites),
                    ),
                    const SizedBox(height: 14),
                    ...nearby.map(
                      (property) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NearbyPropertyRow(
                          property: property,
                          onTap: () => context.push(
                            '${AppRoutes.propertyDetail}/${property.id}',
                          ),
                          onFavorite: () =>
                              favoritesController.toggleFavorite(property.id),
                          isFavorite: favoritesController.isFavorite(
                            property.id,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showQuickMenu(BuildContext context) {
    final auth = context.read<AuthController>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _MenuTile(
                  icon: Icons.add_home_work_outlined,
                  label: 'Add a property',
                  route: AppRoutes.newProperty,
                ),
                const SizedBox(height: 8),
                const _MenuTile(
                  icon: Icons.grid_view_rounded,
                  label: 'My listings',
                  route: AppRoutes.myProperties,
                ),
                const SizedBox(height: 8),
                const _MenuTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  route: AppRoutes.profile,
                ),
                const SizedBox(height: 8),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  tileColor: AppColors.surfaceMuted,
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Log out'),
                  onTap: () async {
                    Navigator.pop(context);
                    await auth.logout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _mapRouteFor(Property? property) {
    if (property == null) return AppRoutes.map;
    return '${AppRoutes.map}?propertyId=${property.id}';
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.iconColor = AppColors.charcoal,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 22,
            color: filled ? AppColors.white : iconColor,
          ),
        ),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD8DBE3), Color(0xFFF8F9FB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected ? AppColors.white : AppColors.charcoal,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FeaturedPropertyCard extends StatelessWidget {
  const _FeaturedPropertyCard({
    required this.property,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final Property property;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 234,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 32,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AppNetworkImage(
                imageUrl: property.heroImage,
                borderRadius: 30,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          property.subtitle ?? property.commune,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.86),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      property.listingLabel ?? 'Sale',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '\$${property.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onFavorite,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyPropertyRow extends StatelessWidget {
  const _NearbyPropertyRow({
    required this.property,
    required this.onTap,
    required this.onFavorite,
    required this.isFavorite,
  });

  final Property property;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(12),
      radius: 24,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: property.heroImage,
              height: 72,
              width: 72,
              borderRadius: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.subtitle ?? property.commune,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${property.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.primary : AppColors.blueGray,
              ),
            ),
          ],
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

class _BottomFloatNav extends StatelessWidget {
  const _BottomFloatNav({
    required this.onExplore,
    required this.onFavorite,
    required this.onMessage,
  });

  final VoidCallback onExplore;
  final VoidCallback onFavorite;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(22, 0, 22, 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const _NavItem(
              icon: Icons.home_filled,
              label: 'Home',
              active: true,
            ),
            _NavItem(
              icon: Icons.explore_outlined,
              label: 'Explore',
              onTap: onExplore,
            ),
            _NavItem(
              icon: Icons.favorite_border_rounded,
              label: 'Favorite',
              onTap: onFavorite,
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Message',
              onTap: onMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: active
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      tileColor: AppColors.surfaceMuted,
      leading: Icon(icon, color: AppColors.charcoal),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: () {
        Navigator.pop(context);
        context.push(route);
      },
    );
  }
}

class _PolishedEmptyState extends StatelessWidget {
  const _PolishedEmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      radius: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.house_siding_rounded,
            size: 42,
            color: AppColors.blueGray,
          ),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
