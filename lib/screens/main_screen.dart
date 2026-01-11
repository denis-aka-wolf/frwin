import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/providers/instrument/instrument_bloc.dart';
import 'package:frwin/providers/instrument/instrument_event.dart';
import 'package:frwin/providers/instrument/instrument_state.dart';
import 'package:frwin/widgets/error_display_widget.dart';
import 'package:frwin/widgets/loading_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch instruments when the screen is initialized
    context.read<InstrumentBloc>().add(const FetchInstruments(category: 'linear'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funding Rate Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: BlocBuilder<InstrumentBloc, InstrumentState>(
        builder: (context, state) {
          if (state is InstrumentLoading) {
            return const LoadingWidget();
          } else if (state is InstrumentLoaded) {
            return ListView.builder(
              itemCount: state.instruments.length,
              itemBuilder: (context, index) {
                final instrument = state.instruments[index];
                return ListTile(
                  title: Text(instrument.symbol),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: instrument);
                  },
                );
              },
            );
          } else if (state is InstrumentError) {
            return ErrorDisplayWidget(
              errorMessage: state.message,
              onRetry: () {
                context
                    .read<InstrumentBloc>()
                    .add(const FetchInstruments(category: 'linear'));
              },
            );
          }
          return const Center(child: Text('Select an instrument.'));
        },
      ),
    );
  }
}