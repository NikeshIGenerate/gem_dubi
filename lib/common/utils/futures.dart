extension Finaly<T> on Future<T> {
  Future<T> onFinally(void Function() function) async {
    try {
      final value = await this;
      function();
      return value;
    } catch (e) {
      function();
      rethrow;
    }
  }
}
