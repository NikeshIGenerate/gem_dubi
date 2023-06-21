import 'package:flutter/services.dart';

class ExpireDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.length == 1 && newValue.text.length == 2) {
      return newValue.copyWith(
        text: '${newValue.text}/',
        selection: TextSelection.fromPosition(
          TextPosition(offset: newValue.selection.baseOffset + 1),
        ),
      );
    }
    if (oldValue.text.length == 3 && newValue.text.length == 2) {
      return newValue.copyWith(
        text: newValue.text[0],
        selection: TextSelection.fromPosition(
          TextPosition(offset: newValue.selection.baseOffset - 1),
        ),
      );
    }

    if (newValue.text.length > 5) {
      return newValue.copyWith(
        text: newValue.text.substring(0, 5),
        selection: TextSelection.fromPosition(const TextPosition(offset: 5)),
      );
    }
    return newValue;
  }
}
