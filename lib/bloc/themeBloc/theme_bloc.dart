import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(backgroundGradient: _defaultGradient)) {
    on<WeatherChanged>(_onWeatherChanged);
  }

  static const Gradient _defaultGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onWeatherChanged(WeatherChanged event, Emitter<ThemeState> emit) {
    emit(ThemeState(
        backgroundGradient: _mapWeatherToGradient(event.weatherCondition)));
  }

  Gradient _mapWeatherToGradient(String condition) {
    if (condition.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0xFF7D7E7D), Color(0xFF82A3A9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (condition.contains('sky')) {
      return const LinearGradient(
        colors: [Color(0xFF2B78E1), Color(0xFF5AD7F7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return _defaultGradient;
  }
}
