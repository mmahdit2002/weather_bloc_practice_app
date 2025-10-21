part of 'forecast_bloc.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastLoaded extends ForecastState {
  final List<DailyForecast> forecast;

  const ForecastLoaded({required this.forecast});

  @override
  List<Object> get props => [forecast];
}

class ForecastError extends ForecastState {
  final String message;

  const ForecastError({required this.message});

  @override
  List<Object> get props => [message];
}
