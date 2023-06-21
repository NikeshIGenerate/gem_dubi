final passwordReg = RegExp(
  r'^(?=(.*[a-z])+)(?=(.*[A-Z])+)(?=(.*[0-9]){2,})(?=(.*[!@#$%^&*()\-__+.]){1,}).{8,}$',
);

final expiryDateReg = RegExp(r'^\d{2}/\d{1,2}');
final intReg = RegExp(r'^\d+$');
