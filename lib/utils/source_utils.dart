import 'package:ansicolor/ansicolor.dart';

({int line, int column}) getLineColumn(String source, int offset) {
  int line = 1;
  int column = 1;

  for (int i = 0; i < offset && i < source.length; i++) {
    if (source[i] == '\n') {
      line++;
      column = 1;
    } else {
      column++;
    }
  }

  return (line: line, column: column);
}

/// Создает визуальный маркер ошибки и сразу показывает пример исправления
String formatErrorSnippet(
  String source,
  int line,
  int column,
  String errorMessage,
) {
  if (source.isEmpty) return '';
  final lines = source.split('\n');

  if (line - 1 >= lines.length) return '';

  final errorLine = lines[line - 1];
  final msg = errorMessage.toLowerCase();

  // Создаем кисти для стиля "а-ля Biome"
  final gray = AnsiPen()..gray(level: 0.5);
  final red = AnsiPen()..red(bold: true);
  final green = AnsiPen()..green();
  final cyan = AnsiPen()..cyan();

  // Форматируем сетку номеров строк (левая панель)
  final lineNum = '$line │ ';
  final padding = ' ' * (line.toString().length + 3);

  // 1. Собираем оригинальное место ошибки
  final buffer = StringBuffer();
  buffer.writeln(
    gray('\n$padding┌─ assets/test.json'),
  ); // Можно прокидывать filePath сюда
  buffer.writeln('${gray(lineNum)}$errorLine');
  buffer.writeln(
    '$padding${gray('│')}${' ' * (column - 1)}${red('▲')}\n$padding${gray('│')}${' ' * (column - 1)}${red('└─ error: $errorMessage')}',
  );

  // 2. Генерируем умное исправление в стиле Biome
  String fixSuggestion = '';

  // Кейс: Незакрытая строка (твой случай)
  if (msg.contains('control character in string') ||
      msg.contains('unterminated string')) {
    final fixedLine = '$errorLine"'; // Просто закрываем кавычкой в конце
    fixSuggestion =
        '''
${gray('$padding┌─ Suggested fix')}
${cyan('$padding│')} ${green('+ $fixedLine')}
${gray('$padding│')} ${gray(' ' * (errorLine.length + 2))}${green('▲ (закройте строку кавычкой)')}
''';
  }
  // Кейс: Забыли кавычку в начале ключа
  else if (msg.contains('expected valid string label')) {
    final fixedLine =
        errorLine.substring(0, column - 1) +
        '"' +
        errorLine.substring(column - 1);
    fixSuggestion =
        '''
${gray('$padding┌─ Suggested fix')}
${cyan('$padding│')} ${green('+ $fixedLine')}
${gray('$padding│')} ${gray(' ' * column)}${green('▲ (добавьте кавычку)')}
''';
  }
  // Кейс: Пропущена запятая
  else if (msg.contains('expected \',\'')) {
    final fixedLine =
        errorLine.substring(0, column - 1) +
        ',' +
        errorLine.substring(column - 1);
    fixSuggestion =
        '''
${gray('$padding┌─ Suggested fix')}
${cyan('$padding│')} ${green('+ $fixedLine')}
${gray('$padding│')} ${gray(' ' * column)}${green('▲ (добавьте запятую)')}
''';
  }

  buffer.write(fixSuggestion);
  return buffer.toString();
}

String getFixSuggestion(String errorMessage) {
  final msg = errorMessage.toLowerCase();

  if (msg.contains('unexpected character') &&
      msg.contains('expected valid string label')) {
    return '💡 Совет: Похоже, вы забыли поставить двойные кавычки "" вокруг ключа или строки.';
  }
  if (msg.contains('expected \',\' or \'}\'')) {
    return '💡 Совет: Проверьте запятые между элементами. Скорее всего, пропущена запятая или закрывающая фигурная скобка `}`.';
  }
  if (msg.contains('expected \',\' or \']\'')) {
    return '💡 Совет: В массиве пропущена запятая или закрывающая квадратная скобка `]`.';
  }
  if (msg.contains('unexpected end of input')) {
    return '💡 Совет: Файл внезапно оборвался. Проверьте, все ли открытые скобки `{` или `[` имеют парные закрывающие скобки.';
  }
  if (msg.contains('unsupported number format')) {
    return '💡 Совет: Неверный формат числа. В JSON числа не могут начинаться с нуля (например, 01) и не могут содержать лишние точки.';
  }
  if (msg.contains('double-quoted string')) {
    return '💡 Совет: В JSON строки ОБЯЗАТЕЛЬНО должны быть в двойных кавычках `"..."`. Одинарные кавычки \'...\' запрещены.';
  }

  return '💡 Совет: Внимательно проверьте синтаксис вокруг указанного места. JSON очень строг к кавычкам, запятым и скобкам.';
}
