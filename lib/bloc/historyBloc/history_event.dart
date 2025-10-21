part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
  @override
  List<Object> get props => [];
}

class AddCityToHistory extends HistoryEvent {
  final String city;
  const AddCityToHistory(this.city);
  @override
  List<Object> get props => [city];
}
