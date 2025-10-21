import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  @override
  List<Object?> get props => [
        cityName,
        temperature,
        description,
        iconCode,
        humidity,
        windSpeed,
        pressure
      ];
}
