class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'حدث خطأ في التخزين المحلي']);

  @override
  String toString() => 'CacheException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'حدث خطأ في الخادم']);

  @override
  String toString() => 'ServerException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'مدخلات غير صحيحة']);

  @override
  String toString() => 'ValidationException: $message';
}
