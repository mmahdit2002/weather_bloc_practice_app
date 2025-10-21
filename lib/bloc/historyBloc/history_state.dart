part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<CityWeather> recentSearches;
  final List<CityWeather> recommendedCities;

  const HistoryLoaded({
    required this.recentSearches,
    required this.recommendedCities,
  });

  @override
  List<Object> get props => [recentSearches, recommendedCities];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object> get props => [message];
}
