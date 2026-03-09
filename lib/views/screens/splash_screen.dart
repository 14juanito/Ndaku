import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: -80,
            top: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x18FE460A),
              ),
            ),
          ),
          Positioned(
            right: -90,
            bottom: -50,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x12000000),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppLogo(size: 124),
                SizedBox(height: 18),
                Text(
                  'Ndaku',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Premium real estate in Kinshasa',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 26),
                CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
