import 'package:ansicolor/ansicolor.dart';

class Logger {
  final _infoPen = AnsiPen()..cyan();
  final _successPen = AnsiPen()..green(bold: true);
  final _warningPen = AnsiPen()..yellow();
  final _errorPen = AnsiPen()..red(bold: true);
  final _timePen = AnsiPen()..gray(level: 0.5); 

  final bool isVerbose;

  Logger({this.isVerbose = false});


  String get _timestamp {
    final now = DateTime.now();
    final timeString = now.toString().split(' ').last.split('.').first;
    return _timePen('[$timeString]');
  }

  void info(String message) => print('${_infoPen('[INFO]')} $_timestamp $message');
  
  void success(String message) => print('${_successPen('[SUCCESS]')} $_timestamp $message');
  
  void warn(String message) => print('${_warningPen('[WARN]')} $_timestamp $message');
  
  void error(String message, [Object? error]) {
    print('${_errorPen('[ERROR]')} $_timestamp $message');
    if (error != null && isVerbose) {
      print('$_timestamp ${_errorPen('  Детали ошибки: $error')}');
    }
  }

  void debug(String message) {
    if (isVerbose) {
      print('$_timestamp ${_timePen('[DEBUG]')} $message');
    }
  }
}