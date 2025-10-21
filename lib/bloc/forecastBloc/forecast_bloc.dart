import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/model/daily_forecast_model.dart';
import 'package:flutter_weather_bloc_app/repository/weather_repository.dart';

part 'forecast_event.dart';
part 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final WeatherRepository weatherRepository;

  ForecastBloc(this.weatherRepository) : super(ForecastInitial()) {
    on<FetchForecast>(_onFetchForecast);
  }

  Future<void> _onFetchForecast(
      FetchForecast event, Emitter<ForecastState> emit) async {
    emit(ForecastLoading());
    try {
      final forecast =
          await weatherRepository.fetchDailyForecast(event.cityName);
      emit(ForecastLoaded(forecast: forecast));
    } catch (e) {
      emit(const ForecastError(message: "Failed to fetch forecast."));
    }
  }
}
