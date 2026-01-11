import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/providers/settings/settings_event.dart';
import 'package:frwin/providers/settings/settings_state.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const String _themeKey = 'theme';
  static const String _intervalKey = 'interval';

  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateRefreshInterval>(_onUpdateRefreshInterval);
  }

  void _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    final interval = prefs.getInt(_intervalKey) ?? 60;
    emit(state.copyWith(
      themeMode: ThemeMode.values[themeIndex],
      refreshInterval: interval,
    ));
  }

  void _onUpdateTheme(UpdateTheme event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onUpdateRefreshInterval(
      UpdateRefreshInterval event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_intervalKey, event.interval);
    emit(state.copyWith(refreshInterval: event.interval));
  }
}