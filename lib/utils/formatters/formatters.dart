import 'package:flutter/services.dart';

class AppFormatters {

  static List<TextInputFormatter> phoneNumberFormatter() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(11), // For 03001234567 format
    ];
  }

  // Name formatter - allows only letters and spaces
  static List<TextInputFormatter> nameFormatter() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), LengthLimitingTextInputFormatter(50)];
  }

  // Email formatter - removes spaces and converts to lowercase
  static List<TextInputFormatter> emailFormatter() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      LengthLimitingTextInputFormatter(100),
      LowerCaseTextFormatter(),
    ];
  }

  // Password formatter - removes spaces
  static List<TextInputFormatter> passwordFormatter() {
    return [FilteringTextInputFormatter.deny(RegExp(r'\s')), LengthLimitingTextInputFormatter(50)];
  }
}

// Custom formatter to convert text to lowercase
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

// Custom formatter to capitalize first letter of each word
class CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final words = text.split(' ');
    final capitalizedWords = words
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');

    return TextEditingValue(text: capitalizedWords, selection: newValue.selection);
  }
}
