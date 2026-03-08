abstract class PropertyImageService {
  Future<String> uploadPropertyImage({
    required String propertyId,
    required String filePath,
  });
}

class StubPropertyImageService implements PropertyImageService {
  @override
  Future<String> uploadPropertyImage({
    required String propertyId,
    required String filePath,
  }) {
    throw UnimplementedError(
      'Upload image will be implemented in Sprint 2 with Firebase Storage.',
    );
  }
}
