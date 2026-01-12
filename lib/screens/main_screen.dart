import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/providers/instrument/instrument_bloc.dart';
import 'package:frwin/providers/instrument/instrument_event.dart';
import 'package:frwin/providers/instrument/instrument_state.dart';
import 'package:frwin/widgets/error_display_widget.dart';
import 'package:frwin/widgets/instrument_data_card.dart';
import 'package:frwin/widgets/loading_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<InstrumentBloc>().add(const FetchInstruments(category: 'linear'));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<InstrumentBloc>().add(const FetchMoreInstruments(category: 'linear'));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
              Navigator.pushNamed(context, '/settings');
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
              controller: _scrollController,
              itemCount: state.hasMore
                  ? state.instruments.length + 1
                  : state.instruments.length,
              itemBuilder: (context, index) {
                if (index >= state.instruments.length) {
                  return const LoadingWidget();
                }
                final instrument = state.instruments[index];
                return InstrumentDataCard(instrument: instrument);
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