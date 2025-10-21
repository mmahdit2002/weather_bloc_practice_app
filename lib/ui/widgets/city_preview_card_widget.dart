import 'package:flutter/material.dart';
import 'package:flutter_weather_bloc_app/model/city_weather_preview_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class CityPreviewCard extends StatelessWidget {
  final CityWeather cityWeather;
  final VoidCallback onTap;

  const CityPreviewCard({
    super.key,
    required this.cityWeather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cityWeather.cityName,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${cityWeather.iconCode}@2x.png',
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_cloudy,
                        color: Colors.white,
                        size: 50),
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
