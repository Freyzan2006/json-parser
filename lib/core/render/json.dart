// lib/core/json_reader.dart
import 'dart:convert';
import 'dart:io';

import 'package:json_parser/core/json/exports.dart';
import 'package:json_parser/exceptions/json_format.dart';
import 'package:json_parser/logger.dart';
import 'package:json_parser/utils/source_utils.dart';

class JsonReader {
  final Logger _logger;

  JsonReader({required Logger logger}) : _logger = logger;

  Future<Json> read(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        _logger.error('File not found: $filePath');
        throw Exception('File not found: $filePath');
      }

      final String contents = await file.readAsString();
      final dynamic jsonData = jsonDecode(contents);

      return Json(data: jsonData);
    } on FormatException catch (e) {
      final sourceStr = e.source as String? ?? '';

      final position = getLineColumn(sourceStr, e.offset ?? 0);

      final snippet = formatErrorSnippet(
        sourceStr,
        position.line,
        position.column,
        e.message,
      );

      _logger.error(
        'Invalid JSON syntax in $filePath at line ${position.line}, col ${position.column}\nError: ${e.message}$snippet',
      );

      throw JsonParseException(
        filePath: filePath,
        source: sourceStr,
        message: '${e.message}$snippet',
        line: position.line,
        column: position.column,
      );
    } on FileSystemException catch (e) {
      _logger.error('File system error: ${e.message}');
      throw Exception('File system error: ${e.message}');
    }
  }
}
