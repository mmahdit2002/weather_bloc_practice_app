import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/forecastBloc/forecast_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/historyBloc/history_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/settingsBloc/settings_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/themeBloc/theme_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/weatherBloc/weather_bloc.dart';
import 'package:flutter_weather_bloc_app/model/city_weather_preview_model.dart';
import 'package:flutter_weather_bloc_app/model/weather_data_model.dart';
import 'package:flutter_weather_bloc_app/ui/widgets/recent_search_tile_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'forecast_page.dart';
import 'settings_page.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: themeState.backgroundGradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocListener<WeatherBloc, WeatherState>(
              listener: (context, weatherState) {
                if (weatherState is WeatherLoaded) {
                  context.read<ThemeBloc>().add(WeatherChanged(
                      weatherCondition: weatherState.weather.description));
                  context.read<ForecastBloc>().add(
                      FetchForecast(cityName: weatherState.weather.cityName));
                  context
                      .read<HistoryBloc>()
                      .add(AddCityToHistory(weatherState.weather.cityName));
                }
              },
              child: const WeatherView(),
            ),
          ),
        );
      },
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final _textController = TextEditingController();
  late final String _formattedDate;

  @override
  void initState() {
    super.initState();
    _formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());
    // Load initial history when the app starts
    context.read<HistoryBloc>().add(const LoadHistory());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                Column(
                  children: [
                    Text('Weather',
                        style: GoogleFonts.raleway(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(_formattedDate,
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8))),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage())),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter City Name',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      context
                          .read<WeatherBloc>()
                          .add(FetchWeather(_textController.text));
                      _textController.clear();
                    }
                  },
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WeatherBloc>().add(FetchWeather(value));
                  _textController.clear();
                }
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                } else if (state is WeatherLoaded) {
                  return WeatherDisplay(weather: state.weather);
                } else if (state is WeatherError) {
                  return ErrorView(message: state.message);
                }
                return const InitialWeatherView();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialWeatherView extends StatelessWidget {
  const InitialWeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (state is HistoryLoaded) {
          if (state.recommendedCities.isEmpty && state.recentSearches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search,
                      size: 60, color: Colors.white.withOpacity(0.7)),
                  const SizedBox(height: 16),
                  Text('Your searches will appear here.',
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 18))
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.recommendedCities.isNotEmpty)
                _buildRecommendedSection(
                    "Recommended", state.recommendedCities, context),
              if (state.recentSearches.isNotEmpty)
                Expanded(
                  child: _buildRecentSearchesSection(
                      "Recent Searches", state.recentSearches, context),
                ),
            ],
          );
        }
        if (state is HistoryError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecommendedSection(
      String title, List<CityWeather> cities, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 4.0, bottom: 8),
          child: Text(title,
              style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        Row(
          children: cities.map((city) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _CityPreviewCard(
                  cityWeather: city,
                  onTap: () {
                    context
                        .read<WeatherBloc>()
                        .add(FetchWeather(city.cityName));
                  },
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRecentSearchesSection(
      String title, List<CityWeather> cities, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8),
          child: Text(title,
              style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return RecentSearchTile(
                cityWeather: city,
                onTap: () {
                  context.read<WeatherBloc>().add(FetchWeather(city.cityName));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CityPreviewCard extends StatelessWidget {
  final CityWeather cityWeather;
  final VoidCallback onTap;

  const _CityPreviewCard({
    required this.cityWeather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 130,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    cityWeather.cityName,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${cityWeather.iconCode}@2x.png',
                    height: 36,
                    width: 36,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_cloudy,
                        color: Colors.white,
                        size: 36),
                  ),
                  Text(
                    '${cityWeather.temperature.toStringAsFixed(0)}°C',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  String _formatTemperature(double temp, TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      temp = temp * 9 / 5 + 32;
    }
    return '${temp.toStringAsFixed(1)}°';
  }

  String _formatWindSpeed(double speed, WindSpeedUnit unit) {
    if (unit == WindSpeedUnit.mph) {
      speed *= 0.621371;
      return '${speed.toStringAsFixed(1)} mph';
    }
    return '${speed.toStringAsFixed(1)} km/h';
  }

  String _formatPressure(int pressure, PressureUnit unit) {
    if (unit == PressureUnit.inHg) {
      double pressureInHg = pressure * 0.02953;
      return '${pressureInHg.toStringAsFixed(2)} inHg';
    }
    return '$pressure hPa';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weather.cityName.toUpperCase(),
                  style: GoogleFonts.lato(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3)),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ]),
                child: Column(
                  children: [
                    Image.network(
                        'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
                        height: 100,
                        width: 100),
                    Text(
                        _formatTemperature(
                            weather.temperature, settingsState.temperatureUnit),
                        style: GoogleFonts.montserrat(
                            fontSize: 64,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                    Text(weather.description,
                        style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9))),
                    const Divider(
                        color: Colors.white54, thickness: 1, height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WeatherDetail(
                            icon: Icons.water_drop_outlined,
                            value: '${weather.humidity}%',
                            label: 'Humidity'),
                        WeatherDetail(
                            icon: Icons.air,
                            value: _formatWindSpeed(
                                weather.windSpeed, settingsState.windSpeedUnit),
                            label: 'Wind'),
                        WeatherDetail(
                            icon: Icons.arrow_downward,
                            value: _formatPressure(
                                weather.pressure, settingsState.pressureUnit),
                            label: 'Pressure'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.calendar_today, color: Colors.white70),
                label: Text('7-Day Forecast',
                    style: GoogleFonts.lato(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ForecastPage(),
                  ));
                },
              ),
              const SizedBox(height: 5),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text('Search another city',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () {
                  context.read<WeatherBloc>().add(ResetWeather());
                  context
                      .read<ThemeBloc>()
                      .add(const WeatherChanged(weatherCondition: 'default'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherDetail(
      {super.key,
      required this.icon,
      required this.value,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value,
            style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.lato(
                color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.amberAccent, size: 60),
          const SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label:
                const Text('Try Again', style: TextStyle(color: Colors.white)),
            onPressed: () {
              context.read<WeatherBloc>().add(ResetWeather());
            },
          )
        ],
      ),
    );
  }
}
