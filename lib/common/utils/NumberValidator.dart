class NumberValidator {
  NumberValidator({this.min, this.max, this.requiredInt = false});

  final int? min;
  final int? max;
  final bool requiredInt;

  String? call(String? value) {
    final num =
        requiredInt ? int.tryParse(value ?? '') : double.tryParse(value ?? '');

    if (num == null) return 'This field is required';

    if (min != null && num < min!) return 'This field cant be less than $min';
    if (max != null && num > max!) return 'This field cant be more than $max';
  }
}


