import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius = 24,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: width,
        child: imageUrl.isEmpty
            ? const _ImageFallback()
            : Image.network(
                imageUrl,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return const _ImageFallback();
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const _ImageFallback(showLoader: true);
                },
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({this.showLoader = false});

  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5E8EE), Color(0xFFF6F7F8)],
        ),
      ),
      child: Center(
        child: showLoader
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.image_outlined,
                color: AppColors.blueGray,
                size: 28,
              ),
      ),
    );
  }
}
