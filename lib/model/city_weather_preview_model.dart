import 'package:equatable/equatable.dart';

class CityWeather extends Equatable {
  final String cityName;
  final double temperature;
  final String iconCode;

  const CityWeather({
    required this.cityName,
    required this.temperature,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [cityName, temperature, iconCode];
}
