import 'package:flutter/services.dart';

class EmojiFilteringTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
     final emojiRegex = RegExp(
        r'[\u{1F600}-\u{1F64F}' // Emoticons
        r'\u{1F300}-\u{1F5FF}' // Misc Symbols and Pictographs
        r'\u{1F680}-\u{1F6FF}' // Transport and Map
        r'\u{1F700}-\u{1F77F}' // Alchemical Symbols
        r'\u{1F780}-\u{1F7FF}' // Geometric Shapes Extended
        r'\u{1F800}-\u{1F8FF}' // Supplemental Arrows-C
        r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
        r'\u{1FA00}-\u{1FA6F}' // Chess Symbols
        r'\u{1FA70}-\u{1FAFF}' // Symbols and Pictographs Extended-A
        r'\u{2600}-\u{26FF}'   // Misc symbols
        r'\u{2700}-\u{27BF}]'  // Dingbats
        , unicode: true);

    // Remove any emoji characters from the new input value
    String newText = newValue.text.replaceAll(emojiRegex, '');

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}


extension StringExtension on String {
  String capitalizeFirstChar(){
    if(isEmpty)return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}