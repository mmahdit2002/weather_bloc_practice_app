import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleTemperatureUnit>(_onToggleTemperatureUnit);
    on<ToggleWindSpeedUnit>(_onToggleWindSpeedUnit);
    on<TogglePressureUnit>(_onTogglePressureUnit);
  }

  void _onToggleTemperatureUnit(
      ToggleTemperatureUnit event, Emitter<SettingsState> emit) {
    final newUnit = state.temperatureUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    emit(state.copyWith(temperatureUnit: newUnit));
  }

  void _onToggleWindSpeedUnit(
      ToggleWindSpeedUnit event, Emitter<SettingsState> emit) {
    final newUnit = state.windSpeedUnit == WindSpeedUnit.kph
        ? WindSpeedUnit.mph
        : WindSpeedUnit.kph;
    emit(state.copyWith(windSpeedUnit: newUnit));
  }

  void _onTogglePressureUnit(
      TogglePressureUnit event, Emitter<SettingsState> emit) {
    final newUnit = state.pressureUnit == PressureUnit.hpa
        ? PressureUnit.inHg
        : PressureUnit.hpa;
    emit(state.copyWith(pressureUnit: newUnit));
  }
}
