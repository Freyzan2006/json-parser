import 'dart:io';
import 'package:args/args.dart';
import 'package:json_parser/config/flags.dart';
import 'package:json_parser/logger.dart'; 


class FlagsCli {
  final List<String> arguments;
  final ArgParser parser; 
  final Logger logger;


  FlagsCli({required this.arguments, required this.logger}) : parser = ArgParser() {
    parser.addOption('file', abbr: 'f');
  }

  List<Flag> execute() {
    final results = parser.parse(arguments); 
    final filePath = results['file'] as String?; 


    if (filePath == null || filePath.isEmpty) {
      logger.error('Ошибка: Не указан путь к файлу через флаг -f');
      return []; 
    }

    final file = File(filePath);


    if (!file.existsSync()) {
      logger.error('Ошибка: Файл по пути "$filePath" не найден.');
      return [];
    }

 
    if (FileSystemEntity.isDirectorySync(filePath)) {
      logger.error('Ошибка: Указанный путь "$filePath" ведет к директории, а нужен файл.');
      return [];
    }
    
    return [Flag<String>(name: 'file', value: filePath)];
  }
}