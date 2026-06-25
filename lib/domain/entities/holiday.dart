import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final DateTime date;
  final String name;

  const Holiday({
    required this.date,
    required this.name,
  });

  @override
  List<Object?> get props => [date, name];

  @override
  String toString() => 'Holiday("$name", ${date.toIso8601String().substring(0, 10)})';
}