import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/property_controller.dart';
import '../../../controllers/session_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/kinshasa_bounds.dart';
import '../../../core/utils/validators.dart';
import '../../../models/property.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/soft_card.dart';

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
  String _selectedType = 'House';

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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            widget.propertyId == null ? 'Add property' : 'Edit property',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
          children: [
            Text(
              widget.propertyId == null
                  ? 'Publish a premium listing'
                  : 'Update your listing',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep the form lightweight for now; Firebase enrichment and media upload can plug in after the UI pass.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            SoftCard(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (value) =>
                          Validators.requiredField(value, fieldName: 'Titre'),
                      decoration: const InputDecoration(labelText: 'Titre'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) => Validators.requiredField(
                        value,
                        fieldName: 'Description',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            validator: (value) => Validators.requiredField(
                              value,
                              fieldName: 'Prix',
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Prix',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'House',
                                child: Text('House'),
                              ),
                              DropdownMenuItem(
                                value: 'Apartment',
                                child: Text('Apartment'),
                              ),
                              DropdownMenuItem(
                                value: 'Office',
                                child: Text('Office'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _communeController,
                      validator: (value) =>
                          Validators.requiredField(value, fieldName: 'Commune'),
                      decoration: const InputDecoration(labelText: 'Commune'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _addressController,
                      validator: (value) =>
                          Validators.requiredField(value, fieldName: 'Adresse'),
                      decoration: const InputDecoration(labelText: 'Adresse'),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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
                            subtitle: 'New Premium Listing',
                            description: _descriptionController.text.trim(),
                            price:
                                double.tryParse(_priceController.text.trim()) ??
                                0,
                            currency: 'USD',
                            type: _selectedType,
                            commune: _communeController.text.trim(),
                            city: 'Kinshasa',
                            country: 'RDC',
                            address: _addressController.text.trim(),
                            latitude: KinshasaBounds.center.latitude,
                            longitude: KinshasaBounds.center.longitude,
                            listingLabel: 'Sale',
                            images: const [],
                          );
                          if (widget.propertyId == null) {
                            await controller.createProperty(property);
                          } else {
                            await controller.updateProperty(property);
                          }
                          if (!context.mounted) return;
                          if (controller.errorMessage != null) {
                            AppSnackbar.showError(
                              context,
                              controller.errorMessage!,
                            );
                          } else {
                            AppSnackbar.showSuccess(
                              context,
                              'Bien enregistre.',
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          widget.propertyId == null
                              ? 'Publier'
                              : 'Mettre a jour',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
