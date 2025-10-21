import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/forecastBloc/forecast_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/settingsBloc/settings_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/themeBloc/theme_bloc.dart';
import 'package:flutter_weather_bloc_app/ui/widgets/forecast_list_item_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: BoxDecoration(gradient: themeState.backgroundGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                '7-Day Forecast',
                style: GoogleFonts.raleway(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: BlocBuilder<ForecastBloc, ForecastState>(
              builder: (context, forecastState) {
                if (forecastState is ForecastLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
                if (forecastState is ForecastLoaded) {
                  return BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, settingsState) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: forecastState.forecast.length,
                        itemBuilder: (context, index) {
                          final dailyData = forecastState.forecast[index];
                          return ForecastListItem(
                            forecast: dailyData,
                            unit: settingsState.temperatureUnit,
                          );
                        },
                      );
                    },
                  );
                }
                if (forecastState is ForecastError) {
                  return Center(
                    child: Text(forecastState.message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                  );
                }
                return const Center(
                  child: Text('Something went wrong.',
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
