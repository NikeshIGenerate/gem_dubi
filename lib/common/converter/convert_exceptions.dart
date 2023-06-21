class InvalidFormatException implements Exception {}

class UnKnownConverter implements Exception {
  UnKnownConverter([this.type]);

  final Type? type;

  @override
  String toString() {
    return 'UnKnownConverter of $type';
  }
}
