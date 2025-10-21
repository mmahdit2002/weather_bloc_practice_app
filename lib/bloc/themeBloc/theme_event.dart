part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class WeatherChanged extends ThemeEvent {
  final String weatherCondition;

  const WeatherChanged({required this.weatherCondition});

  @override
  List<Object> get props => [weatherCondition];
}
