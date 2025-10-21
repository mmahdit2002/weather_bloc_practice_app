import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_bloc_app/model/weather_data_model.dart';
import 'package:flutter_weather_bloc_app/repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<ResetWeather>(_onResetWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError('Could not fetch weather. Is the city name correct?'));
    }
  }

  void _onResetWeather(ResetWeather event, Emitter<WeatherState> emit) {
    emit(WeatherInitial());
  }
}
