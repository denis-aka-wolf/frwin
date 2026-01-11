import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateTheme extends SettingsEvent {
  final ThemeMode themeMode;

  const UpdateTheme({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class UpdateRefreshInterval extends SettingsEvent {
  final int interval;

  const UpdateRefreshInterval({required this.interval});

  @override
  List<Object> get props => [interval];
}