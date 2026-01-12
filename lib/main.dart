import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/app/core/di/di_container.dart';
import 'package:frwin/providers/funding_rate/funding_rate_bloc.dart';
import 'package:frwin/providers/instrument/instrument_bloc.dart';
import 'package:frwin/providers/settings/settings_bloc.dart';
import 'package:frwin/providers/settings/settings_event.dart';
import 'package:frwin/providers/settings/settings_state.dart';
import 'package:frwin/screens/funding_rate_detail_screen.dart';
import 'package:frwin/screens/main_screen.dart';
import 'package:frwin/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider(create: (context) => getIt<InstrumentBloc>()),
        BlocProvider(create: (context) => getIt<FundingRateBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Funding Rate Monitor',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const MainScreen(),
              '/details': (context) => const FundingRateDetailScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
