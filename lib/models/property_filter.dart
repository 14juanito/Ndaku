class PropertyFilter {
  const PropertyFilter({
    this.minPrice,
    this.maxPrice,
    this.commune,
    this.query,
  });

  final double? minPrice;
  final double? maxPrice;
  final String? commune;
  final String? query;

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      (commune == null || commune!.isEmpty) &&
      (query == null || query!.isEmpty);
}
