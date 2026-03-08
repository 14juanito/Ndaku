import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../controllers/map_controller.dart';
import '../../../core/constants/kinshasa_bounds.dart';
import '../../widgets/app_snackbar.dart';

class KinshasaMapScreen extends StatelessWidget {
  const KinshasaMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapController>();
    final selected = controller.selectedPosition;
    final markers = <Marker>{
      if (selected != null)
        Marker(markerId: const MarkerId('selected'), position: selected),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Carte Kinshasa')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: KinshasaBounds.center,
          zoom: 11.5,
        ),
        markers: markers,
        onTap: (position) {
          final ok = context.read<MapController>().selectPosition(position);
          if (!ok && context.mounted) {
            AppSnackbar.showError(
              context,
              controller.errorMessage ?? 'Position hors Kinshasa',
            );
          }
        },
      ),
    );
  }
}
