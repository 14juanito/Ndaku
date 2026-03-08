import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/property.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.trailing,
  });

  final Property property;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          property.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('${property.commune}, ${property.city}'),
        trailing:
            trailing ??
            Text(
              '${property.price.toStringAsFixed(0)} ${property.currency}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
    );
  }
}
