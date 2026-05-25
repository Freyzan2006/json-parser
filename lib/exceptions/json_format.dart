class JsonParseException implements Exception {
  final String filePath;
  final String source;
  final String message;
  final int line;
  final int column;

  JsonParseException({
    required this.filePath,
    required this.source,
    required this.message,
    required this.line,
    required this.column,
  });

  String pretty() {
    final lines = source.split('\n');

    final errorLine = lines[line - 1];

    return '''
JSON Parse Error

File: $filePath
Line: $line
Column: $column

$line | $errorLine
${' ' * (line.toString().length)} | ${' ' * (column - 1)}^

$message
''';
  }

  @override
  String toString() => pretty();
}
