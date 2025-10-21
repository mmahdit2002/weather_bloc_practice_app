import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/settingsBloc/settings_bloc.dart';
import 'package:flutter_weather_bloc_app/bloc/themeBloc/theme_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                'Settings',
                style: GoogleFonts.raleway(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
              return ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _buildSettingsRow(context,
                      title: 'Temperature Unit',
                      value: settingsState.temperatureUnit ==
                          TemperatureUnit.fahrenheit,
                      onChanged: (_) => context
                          .read<SettingsBloc>()
                          .add(const ToggleTemperatureUnit()),
                      activeLabel: '°F',
                      inactiveLabel: '°C'),
                  const SizedBox(height: 16),
                  _buildSettingsRow(context,
                      title: 'Wind Speed Unit',
                      value: settingsState.windSpeedUnit == WindSpeedUnit.mph,
                      onChanged: (_) => context
                          .read<SettingsBloc>()
                          .add(const ToggleWindSpeedUnit()),
                      activeLabel: 'mph',
                      inactiveLabel: 'km/h'),
                  const SizedBox(height: 16),
                  _buildSettingsRow(context,
                      title: 'Pressure Unit',
                      value: settingsState.pressureUnit == PressureUnit.inHg,
                      onChanged: (_) => context
                          .read<SettingsBloc>()
                          .add(const TogglePressureUnit()),
                      activeLabel: 'inHg',
                      inactiveLabel: 'hPa'),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String activeLabel,
    required String inactiveLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
          ),
          Row(
            children: [
              Text(inactiveLabel,
                  style: GoogleFonts.lato(
                      color: value ? Colors.white54 : Colors.white,
                      fontSize: 14)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: Colors.tealAccent.withOpacity(0.5),
                activeColor: Colors.tealAccent,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.4),
              ),
              Text(activeLabel,
                  style: GoogleFonts.lato(
                      color: value ? Colors.white : Colors.white54,
                      fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}
