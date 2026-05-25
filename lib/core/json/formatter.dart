import 'theme.dart';

class JsonFormatter {
  final JsonColorTheme _theme;

 
  JsonFormatter({JsonColorTheme? theme}) : _theme = theme ?? JsonColorTheme.instance;

  String format(dynamic value, [int indentLevel = 0]) {
    final indent = '  ' * indentLevel;
    final nextIndent = '  ' * (indentLevel + 1);

    // 1. Обработка Map
    if (value is Map) {
      if (value.isEmpty) return _theme.bracketPen('{}');
      
      final buffer = StringBuffer();
      buffer.writeln(_theme.bracketPen('{'));
      
      final entries = value.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final isLast = i == entries.length - 1;
        
        final formattedKey = _theme.keyPen('"${entry.key}"');
        final formattedValue = format(entry.value, indentLevel + 1);
        final comma = isLast ? '' : _theme.bracketPen(',');
        
        buffer.writeln('$nextIndent$formattedKey${_theme.bracketPen(': ')}$formattedValue$comma');
      }
      
      buffer.write('$indent${_theme.bracketPen('}')}');
      return buffer.toString();
    }

    // 2. Обработка List
    if (value is List) {
      if (value.isEmpty) return _theme.bracketPen('[]');
      
      final buffer = StringBuffer();
      buffer.writeln(_theme.bracketPen('['));
      
      for (var i = 0; i < value.length; i++) {
        final isLast = i == value.length - 1;
        final formattedElement = format(value[i], indentLevel + 1);
        final comma = isLast ? '' : _theme.bracketPen(',');
        
        buffer.writeln('$nextIndent$formattedElement$comma');
      }
      
      buffer.write('$indent${_theme.bracketPen(']')}');
      return buffer.toString();
    }

    // 3. Обработка примитивов
    if (value is String) {
      return _theme.stringPen('"$value"');
    } else if (value is num) {
      return _theme.numberPen(value.toString());
    } else if (value is bool) {
      return _theme.booleanPen(value.toString());
    } else if (value == null) {
      return _theme.booleanPen('null');
    }

    return value.toString();
  }
}