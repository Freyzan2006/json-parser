import 'package:ansicolor/ansicolor.dart';

class JsonColorTheme {
  final keyPen = AnsiPen()..blue(bold: true);     
  final stringPen = AnsiPen()..green();           
  final numberPen = AnsiPen()..yellow();          
  final booleanPen = AnsiPen()..magenta();        
  final bracketPen = AnsiPen()..gray(level: 0.5); 


  static final JsonColorTheme instance = JsonColorTheme();
}
