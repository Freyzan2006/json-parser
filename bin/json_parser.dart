import 'package:json_parser/config/config.dart';
import 'package:json_parser/core/exports.dart';
import 'package:json_parser/core/json/exports.dart';
import 'package:json_parser/logger.dart';

import 'dart:io';

Future<void> main(List<String> arguments) async {
  final Logger logger = Logger(isVerbose: true);

  final flagsCli = FlagsCli(arguments: arguments, logger: logger);
  final flagsList = flagsCli.execute();
  final flagsObj = Flags(flagsList);

  final fileFlag = flagsObj.getFlag('file');

  if (fileFlag != null) {
    logger.success('fileFlag: ${fileFlag.value}');
  } else {
    logger.error('Флаг "file" не был успешно инициализирован.');
    return;
  }

  try {
    JsonReader reader = JsonReader(logger: logger);
    Json json = await reader.read(fileFlag.value);
    print(json);
  } catch (e) {
    // Ошибка уже красиво раскрасилась внутри JsonReader,
    // тут просто предотвращаем падение приложения
    exit(1);
  }
}
