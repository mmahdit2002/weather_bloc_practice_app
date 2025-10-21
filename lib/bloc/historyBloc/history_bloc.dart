import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/model/city_weather_preview_model.dart';
import 'package:flutter_weather_bloc_app/repository/search_history_repository.dart';
import 'package:flutter_weather_bloc_app/repository/weather_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final SearchHistoryRepository searchHistoryRepository;
  final WeatherRepository weatherRepository;

  HistoryBloc(this.searchHistoryRepository, this.weatherRepository)
      : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<AddCityToHistory>(_onAddCityToHistory);
  }

  Future<void> _onLoadHistory(
      LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final results = await Future.wait([
        _getRecentSearches(),
        _getRecommendedCities(),
      ]);
      emit(HistoryLoaded(
        recentSearches: results[0],
        recommendedCities: results[1],
      ));
    } catch (_) {
      emit(const HistoryError("Could not load cities."));
    }
  }

  Future<void> _onAddCityToHistory(
      AddCityToHistory event, Emitter<HistoryState> emit) async {
    await searchHistoryRepository.addSearchTerm(event.city);
    add(const LoadHistory());
  }

  Future<List<CityWeather>> _getRecentSearches() async {
    final cityNames = await searchHistoryRepository.getSearchHistory();
    if (cityNames.isEmpty) return [];
    return await weatherRepository.fetchWeatherForCities(cityNames);
  }

  Future<List<CityWeather>> _getRecommendedCities() async {
    final cityNames = await weatherRepository.fetchRecommendedCities();
    return await weatherRepository.fetchWeatherForCities(cityNames);
  }
}
