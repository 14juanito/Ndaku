import 'package:flutter/material.dart';

import '../../models/property_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key, required this.initialFilter});

  final PropertyFilter initialFilter;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _communeController;
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialFilter.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilter.maxPrice?.toString() ?? '',
    );
    _communeController = TextEditingController(
      text: widget.initialFilter.commune ?? '',
    );
    _queryController = TextEditingController(
      text: widget.initialFilter.query ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _communeController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const Text('Filtres'),
          TextField(
            controller: _queryController,
            decoration: const InputDecoration(labelText: 'Recherche'),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Prix min'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Prix max'),
                ),
              ),
            ],
          ),
          TextField(
            controller: _communeController,
            decoration: const InputDecoration(labelText: 'Commune'),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  PropertyFilter(
                    minPrice: double.tryParse(_minPriceController.text.trim()),
                    maxPrice: double.tryParse(_maxPriceController.text.trim()),
                    commune: _communeController.text.trim(),
                    query: _queryController.text.trim(),
                  ),
                );
              },
              child: const Text('Appliquer'),
            ),
          ),
        ],
      ),
    );
  }
}
