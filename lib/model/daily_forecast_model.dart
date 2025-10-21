import 'package:equatable/equatable.dart';

class DailyForecast extends Equatable {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String iconCode;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [date, maxTemp, minTemp, description, iconCode];
}
