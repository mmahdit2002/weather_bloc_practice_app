import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/forecastBloc/forecast_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/historyBloc/history_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/settingsBloc/settings_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/themeBloc/theme_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/weatherBloc/weather_bloc.dart';
import 'package:flutter_weather_bloc_app/repository/search_history_repository.dart';
import 'package:flutter_weather_bloc_app/repository/weather_repository.dart';
import 'package:flutter_weather_bloc_app/ui/pages/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => WeatherRepository()),
        RepositoryProvider(create: (context) => SearchHistoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  WeatherBloc(context.read<WeatherRepository>())),
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(create: (context) => SettingsBloc()),
          BlocProvider(
              create: (context) =>
                  ForecastBloc(context.read<WeatherRepository>())),
          BlocProvider(
            create: (context) => HistoryBloc(
              context.read<SearchHistoryRepository>(),
              context.read<WeatherRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Weather BLoC',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const WeatherPage(),
        ),
      ),
    );
  }
}
