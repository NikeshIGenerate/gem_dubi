class CustomInputValidator {
  /// has three state [true] [false] [null]
  final bool? isRequired;
  final bool? isInt;
  final bool? isDouble;
  final int? minLength;
  final int? maxLength;
  final double? min;
  final double? max;

  final bool email;
  final bool url;
  final bool phone;
  final bool userName;

  CustomInputValidator({
    this.isInt,
    this.isDouble,
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.isRequired,
    this.email = false,
    this.phone = false,
    this.url = false,
    this.userName = false,
  });

  static final RegExp _userNameRegExp =
      RegExp(r'^(?=[a-zA-Z0-9._]*$)(?!.*[_.]{2})[^_.].*[^_.]$');
  static final RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-\_]+(\.[a-zA-Z]+)*$");
  static final RegExp _nonDigitsExp = RegExp(r'[^\d]');
  static final RegExp _anyLetter = RegExp(r'[A-Za-z]');
  static final RegExp _phoneRegExp = RegExp(r'^\d{7,15}$');
  static final RegExp _ipv4RegExp = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  static final RegExp _ipv6RegExp = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$');
  static final RegExp _urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

  String? call(String? value) {
    /// allow to add non required fields
    if (isRequired == false) {
      if (value == null || value == '') return null;
    }

    if (isRequired == true) {
      if (value == null || value == '') return 'This field is required';
    }

    if (isInt == true) {
      var res = int.tryParse(value ?? '');
      if (res == null) return 'Invalid number value';
    }

    if (isDouble == true) {
      var res = double.tryParse(value ?? '');
      if (res == null) return 'Invalid number value';
    }

    if (minLength != null) {
      if (value == null || value.length < minLength!) {
        return 'Must be $minLength+ character length';
      }
    }

    if (maxLength != null) {
      if (value != null && value.length > maxLength!) {
        return 'Must be less than $minLength character length';
      }
    }

    if (min != null) {
      var res = double.tryParse(value ?? '');
      if (res != null && res < min!) {
        return 'Must be larger than or equal $min';
      }
    }

    if (max != null) {
      var res = double.tryParse(value ?? '');
      if (res != null && res > max!) {
        return 'Must be more than or equal $max';
      }
    }

    if (email && !_emailRegExp.hasMatch(value!)) {
      return 'Invalid email address';
    }

    if (url && !_urlRegExp.hasMatch(value!)) {
      return 'Invalid url';
    }

    if (phone && !_phoneRegExp.hasMatch(value!)) {
      return 'Invalid phone number';
    }

    if (userName && !_userNameRegExp.hasMatch(value!)) {
      return 'Invalid user name';
    }

    return null;
  }
}
