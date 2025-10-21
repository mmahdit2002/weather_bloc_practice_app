part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final Gradient backgroundGradient;

  const ThemeState({required this.backgroundGradient});

  @override
  List<Object> get props => [backgroundGradient];
}
