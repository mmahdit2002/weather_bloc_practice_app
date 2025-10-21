part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleTemperatureUnit extends SettingsEvent {
  const ToggleTemperatureUnit();
}

class ToggleWindSpeedUnit extends SettingsEvent {
  const ToggleWindSpeedUnit();
}

class TogglePressureUnit extends SettingsEvent {
  const TogglePressureUnit();
}
