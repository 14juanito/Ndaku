import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../../core/constants/kinshasa_bounds.dart';
import '../../../core/utils/validators.dart';
import '../../../models/property.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/loading_overlay.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key, this.propertyId});

  final String? propertyId;

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _communeController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _communeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PropertyController>();
    final session = context.watch<SessionController>();
    return LoadingOverlay(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.propertyId == null ? 'Ajouter un bien' : 'Modifier bien',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Titre'),
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Description'),
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Prix'),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Prix'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _communeController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Commune'),
                  decoration: const InputDecoration(labelText: 'Commune'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Adresse'),
                  decoration: const InputDecoration(labelText: 'Adresse'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final user = session.currentUser;
                    if (user == null) {
                      AppSnackbar.showError(
                        context,
                        'Connecte-toi pour ajouter un bien.',
                      );
                      return;
                    }
                    final property = Property(
                      id:
                          widget.propertyId ??
                          'local_${DateTime.now().millisecondsSinceEpoch}',
                      ownerId: user.id,
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      price: double.tryParse(_priceController.text.trim()) ?? 0,
                      currency: 'USD',
                      type: 'Maison',
                      commune: _communeController.text.trim(),
                      city: 'Kinshasa',
                      country: 'RDC',
                      address: _addressController.text.trim(),
                      latitude: KinshasaBounds.center.latitude,
                      longitude: KinshasaBounds.center.longitude,
                    );
                    if (widget.propertyId == null) {
                      await controller.createProperty(property);
                    } else {
                      await controller.updateProperty(property);
                    }
                    if (!context.mounted) return;
                    if (controller.errorMessage != null) {
                      AppSnackbar.showError(context, controller.errorMessage!);
                    } else {
                      AppSnackbar.showSuccess(context, 'Bien enregistre.');
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.propertyId == null ? 'Publier' : 'Mettre a jour',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
