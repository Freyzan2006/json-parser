import 'package:collection/collection.dart';


class Flag<T> {
  final String name;
  final T? value;

  Flag({required this.name, this.value});
}

class Flags {
  final List<Flag> flags;

  Flags(this.flags);


  Flag? getFlag(String name) => flags.firstWhereOrNull((flag) => flag.name == name);
}
