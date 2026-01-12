import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/providers/settings/settings_bloc.dart';
import 'package:frwin/providers/settings/settings_event.dart';
import 'package:frwin/providers/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Theme'),
                trailing: DropdownButton<ThemeMode>(
                  value: state.themeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (themeMode) {
                    if (themeMode != null) {
                      context
                          .read<SettingsBloc>()
                          .add(UpdateTheme(themeMode: themeMode));
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Card Height'),
                subtitle: Slider(
                  value: state.cardHeight,
                  min: 100,
                  max: 500,
                  divisions: 4,
                  label: state.cardHeight.round().toString(),
                  onChanged: (height) {
                    context
                        .read<SettingsBloc>()
                        .add(UpdateCardHeight(height: height));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}