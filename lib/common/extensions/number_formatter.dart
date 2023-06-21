extension NumbersExtensions on num {
  String toHumanString([int digits = 2]) {
    if (this > 1000) {
      return toInt().toString();
    }

    return toStringAsFixed(digits)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
