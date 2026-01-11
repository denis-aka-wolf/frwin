import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final int refreshInterval;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.refreshInterval = 60,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    int? refreshInterval,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      refreshInterval: refreshInterval ?? this.refreshInterval,
    );
  }

  @override
  List<Object> get props => [themeMode, refreshInterval];
}