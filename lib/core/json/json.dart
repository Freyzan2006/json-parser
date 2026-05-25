import 'formatter.dart';

class Json {
  final Map<String, dynamic> data;
  final JsonFormatter _formatter;

  Json({required this.data}) : _formatter = JsonFormatter();  

  @override
  String toString() {
    return _formatter.format(data);
  }
}