import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/property_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/property.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/soft_card.dart';

class KinshasaMapScreen extends StatelessWidget {
  const KinshasaMapScreen({super.key, this.propertyId});

  final String? propertyId;

  @override
  Widget build(BuildContext context) {
    final properties = context.watch<PropertyController>().properties;
    final property =
        _findProperty(properties) ??
        (properties.isNotEmpty ? properties.first : null);

    if (property == null) {
      return const Scaffold(
        body: Center(child: Text('Aucune propriete disponible.')),
      );
    }

    final reviews = [
      _ReviewCardData(
        author: property.reviewAuthor ?? 'Sanjeev Mehta',
        avatar: property.reviewAvatar ?? property.agentAvatar ?? '',
        rating: property.rating ?? 4.0,
        text:
            property.reviewText ??
            'The place feels polished, convenient, and genuinely premium.',
      ),
      const _ReviewCardData(
        author: 'Rajeev Malhotra',
        avatar:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=128&q=80',
        rating: 4.0,
        text:
            'The location is convenient, serene, and the neighborhood is well connected.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(22, 0, 22, 18),
        child: ElevatedButton(
          onPressed: () {
            AppSnackbar.showSuccess(
              context,
              'Reservation initiee pour ${property.title}.',
            );
          },
          child: const Text('Book now'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          children: [
            SoftCard(
              child: Row(
                children: [
                  AppNetworkImage(
                    imageUrl: property.agentAvatar ?? '',
                    height: 54,
                    width: 54,
                    borderRadius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.agentName ?? 'Aman Dhingra',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          property.agentRole ?? 'Real Estate Agent',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _IconBubble(
                    icon: Icons.call_outlined,
                    onTap: () => AppSnackbar.showSuccess(
                      context,
                      'Appel de ${property.agentName ?? 'l-agent'} en preparation.',
                    ),
                  ),
                  const SizedBox(width: 8),
                  _IconBubble(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => AppSnackbar.showSuccess(
                      context,
                      'Message a ${property.agentName ?? 'l-agent'} pret.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Public Facilities',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _FacilityChip(
                  icon: Icons.temple_buddhist_outlined,
                  label: 'Temple',
                ),
                _FacilityChip(
                  icon: Icons.train_outlined,
                  label: 'Railway Station',
                ),
                _FacilityChip(
                  icon: Icons.restaurant_outlined,
                  label: 'Restaurant',
                ),
                _FacilityChip(icon: Icons.school_outlined, label: 'School'),
                _FacilityChip(
                  icon: Icons.directions_bus_outlined,
                  label: 'Bus Stand',
                ),
                _FacilityChip(
                  icon: Icons.local_hospital_outlined,
                  label: 'Hospital',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Location',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            SoftCard(
              padding: const EdgeInsets.all(0),
              radius: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  height: 240,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const _MapPreviewBackground(),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${property.commune}, ${property.city}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const Positioned(right: 66, top: 102, child: _MapPin()),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Reviews (${property.reviewCount ?? 120})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  'See all',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.blueGray,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 176,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reviews.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return SizedBox(
                    width: 255,
                    child: SoftCard(
                      padding: const EdgeInsets.all(16),
                      radius: 26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppNetworkImage(
                                imageUrl: review.avatar,
                                height: 42,
                                width: 42,
                                borderRadius: 14,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  review.author,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(14),
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
                                      review.rating.toStringAsFixed(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            review.text,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  height: 1.55,
                                  color: AppColors.textSecondary,
                                ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Property? _findProperty(List<Property> properties) {
    if (propertyId == null || propertyId!.isEmpty) return null;
    try {
      return properties.firstWhere((item) => item.id == propertyId);
    } catch (_) {
      return null;
    }
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: AppColors.blueGray),
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.blueGray, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MapPreviewBackground extends StatelessWidget {
  const _MapPreviewBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE7EFEA), Color(0xFFF6F4ED)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: 34,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 220,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7D7D0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            right: -40,
            top: 84,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 250,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3DDD6),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            left: 70,
            bottom: 42,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 210,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFD6E1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 28,
            top: 70,
            child: _MapLabel(text: 'Ngaliema'),
          ),
          const Positioned(
            right: 28,
            bottom: 26,
            child: _MapLabel(text: 'Kinshasa'),
          ),
        ],
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: AppColors.logoOrange,
            shape: BoxShape.circle,
          ),
        ),
        Container(width: 4, height: 24, color: AppColors.logoOrange),
      ],
    );
  }
}

class _ReviewCardData {
  const _ReviewCardData({
    required this.author,
    required this.avatar,
    required this.rating,
    required this.text,
  });

  final String author;
  final String avatar;
  final double rating;
  final String text;
}
