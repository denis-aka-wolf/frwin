import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final int refreshInterval;
  final double cardHeight;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.refreshInterval = 60,
    this.cardHeight = 150.0,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    int? refreshInterval,
    double? cardHeight,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      cardHeight: cardHeight ?? this.cardHeight,
    );
  }

  @override
  List<Object> get props => [themeMode, refreshInterval, cardHeight];
}