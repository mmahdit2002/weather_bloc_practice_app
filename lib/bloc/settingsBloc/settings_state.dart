part of 'settings_bloc.dart';

enum TemperatureUnit { celsius, fahrenheit }

enum WindSpeedUnit { kph, mph }

enum PressureUnit { hpa, inHg }

class SettingsState extends Equatable {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final PressureUnit pressureUnit;

  const SettingsState({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.kph,
    this.pressureUnit = PressureUnit.hpa,
  });

  SettingsState copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
  }) {
    return SettingsState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
    );
  }

  @override
  List<Object> get props => [temperatureUnit, windSpeedUnit, pressureUnit];
}
