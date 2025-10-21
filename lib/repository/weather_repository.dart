import 'dart:math';

import 'package:flutter_weather_bloc_app/model/city_weather_preview_model.dart';
import 'package:flutter_weather_bloc_app/model/daily_forecast_model.dart';
import 'package:flutter_weather_bloc_app/model/weather_data_model.dart';

class WeatherRepository {
  Future<Weather> fetchWeather(String cityName) async {
    await Future.delayed(const Duration(seconds: 1));
    if (cityName.toLowerCase() == 'error') {
      throw Exception('Something went wrong!');
    }
    final random = Random();
    final descriptionIndex = random.nextInt(4);
    final mockWeather = Weather(
      cityName: cityName,
      temperature: 10 + random.nextInt(25).toDouble() + random.nextDouble(),
      description: _getMockDescription(descriptionIndex),
      iconCode: _getMockIcon(descriptionIndex),
      humidity: 40 + random.nextInt(50),
      windSpeed: 2.0 + random.nextInt(10).toDouble(),
      pressure: 980 + random.nextInt(40),
    );
    return mockWeather;
  }

  Future<List<DailyForecast>> fetchDailyForecast(String cityName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (cityName.toLowerCase() == 'error') {
      throw Exception('Could not fetch forecast!');
    }
    final random = Random();
    return List.generate(7, (index) {
      final descriptionIndex = random.nextInt(4);
      final maxTemp = 15.0 + random.nextInt(10) + random.nextDouble();
      return DailyForecast(
        date: DateTime.now().add(Duration(days: index + 1)),
        maxTemp: maxTemp,
        minTemp: maxTemp - (5 + random.nextInt(5).toDouble()),
        description: _getMockDescription(descriptionIndex),
        iconCode: _getMockIcon(descriptionIndex),
      );
    });
  }

  Future<List<CityWeather>> fetchWeatherForCities(List<String> cities) async {
    final weatherList = <CityWeather>[];
    final random = Random();
    for (final city in cities) {
      await Future.delayed(const Duration(milliseconds: 100));
      weatherList.add(CityWeather(
        cityName: city,
        temperature: 10 + random.nextInt(25).toDouble() + random.nextDouble(),
        iconCode: _getMockIcon(random.nextInt(4)),
      ));
    }
    return weatherList;
  }

  Future<List<String>> fetchRecommendedCities() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ['Tokyo', 'Paris', 'New York'];
  }

  String _getMockDescription(int index) {
    const descriptions = [
      'clear sky',
      'few clouds',
      'scattered clouds',
      'broken clouds'
    ];
    return descriptions[index];
  }

  String _getMockIcon(int index) {
    const icons = ['01d', '02d', '03d', '04d'];
    return icons[index];
  }
}
