import 'package:flutter/material.dart';
import 'package:flutter_weather_bloc_app/bloc/settingsBloc/settings_bloc.dart';
import 'package:flutter_weather_bloc_app/model/daily_forecast_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ForecastListItem extends StatelessWidget {
  final DailyForecast forecast;
  final TemperatureUnit unit;

  const ForecastListItem({
    super.key,
    required this.forecast,
    required this.unit,
  });

  String _formatTemperature(double temp) {
    if (unit == TemperatureUnit.fahrenheit) {
      temp = temp * 9 / 5 + 32;
    }
    return '${temp.toStringAsFixed(0)}°';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              DateFormat('EEEE').format(forecast.date), // Day of the week
              style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
            ),
          ),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.iconCode}@2x.png',
            height: 40,
            width: 40,
          ),
          Text(
            '${_formatTemperature(forecast.maxTemp)} / ${_formatTemperature(forecast.minTemp)}',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
