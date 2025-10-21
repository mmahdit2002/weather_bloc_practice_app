import 'package:flutter/material.dart';
import 'package:flutter_weather_bloc_app/model/city_weather_preview_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class RecentSearchTile extends StatelessWidget {
  final CityWeather cityWeather;
  final VoidCallback onTap;

  const RecentSearchTile({
    super.key,
    required this.cityWeather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cityWeather.cityName,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Image.network(
                    'https://openweathermap.org/img/wn/${cityWeather.iconCode}@2x.png',
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_cloudy,
                        color: Colors.white,
                        size: 40),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 70,
                    child: Text(
                      '${cityWeather.temperature.toStringAsFixed(0)}°C',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 22,
                      ),
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
