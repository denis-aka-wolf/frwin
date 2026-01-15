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
  bool _useFixedLimits = true; // Режим с фиксацией по умолчанию

  void toggleFixedLimits() {
    setState(() {
      _useFixedLimits = !_useFixedLimits;
    });
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildFilterControls(
              context: context,
              useFixedLimits: _useFixedLimits,
              onUseFixedLimitsChanged: (bool value) {
                setState(() {
                  _useFixedLimits = value;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<InstrumentBloc, InstrumentState>(
              builder: (context, state) {
                if (state is InstrumentLoading) {
                  return const LoadingWidget();
                } else if (state is InstrumentLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasMore
                        ? state.filteredInstruments.length + 1
                        : state.filteredInstruments.length,
                    itemBuilder: (context, index) {
                      if (index >= state.filteredInstruments.length) {
                        return const LoadingWidget();
                      }
                      final instrument = state.filteredInstruments[index];
                      return InstrumentDataCard(
                        instrument: instrument,
                        useFixedLimits: _useFixedLimits,
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
          ),
        ],
      ),
    );
  }
}

  Widget _buildFilterControls({
    required BuildContext context,
    required bool useFixedLimits,
    required void Function(bool) onUseFixedLimitsChanged,
  }) {
    final state = context.watch<InstrumentBloc>().state;
    String? symbolFilter;
    int? fundingIntervalFilter;

    if (state is InstrumentLoaded) {
      symbolFilter = state.symbolFilter;
      fundingIntervalFilter = state.fundingIntervalFilter;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Filter by Symbol',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<InstrumentBloc>().add(FilterInstruments(symbol: value));
                },
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: fundingIntervalFilter,
              hint: const Text('Funding Interval'),
              items: const [
                DropdownMenuItem(value: 60, child: Text('1h')),
                DropdownMenuItem(value: 240, child: Text('4h')),
                DropdownMenuItem(value: 480, child: Text('8h')),
              ],
              onChanged: (value) {
                context.read<InstrumentBloc>().add(FilterInstruments(fundingInterval: value));
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                context.read<InstrumentBloc>().add(ResetFilter());
              },
              child: const Text('Сбросить'),
            ),
          ],
        ),
        SwitchListTile(
          title: const Text('Use fixed limits'),
          value: useFixedLimits,
          onChanged: onUseFixedLimitsChanged,
        ),
      ],
    );
  }