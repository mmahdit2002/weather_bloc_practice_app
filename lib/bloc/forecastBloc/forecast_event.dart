part of 'forecast_bloc.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();
}

class FetchForecast extends ForecastEvent {
  final String cityName;

  const FetchForecast({required this.cityName});

  @override
  List<Object> get props => [cityName];
}
