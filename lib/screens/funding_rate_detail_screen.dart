import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:frwin/providers/funding_rate/funding_rate_bloc.dart';
import 'package:frwin/providers/funding_rate/funding_rate_event.dart';
import 'package:frwin/providers/funding_rate/funding_rate_state.dart';
import 'package:frwin/providers/settings/settings_bloc.dart';
import 'package:frwin/providers/settings/settings_state.dart';
import 'package:frwin/widgets/error_display_widget.dart';
import 'package:frwin/widgets/loading_widget.dart';
import 'package:frwin/widgets/funding_rate_chart.dart';

class FundingRateDetailScreen extends StatefulWidget {
  const FundingRateDetailScreen({super.key});

  @override
  State<FundingRateDetailScreen> createState() =>
      _FundingRateDetailScreenState();
}

class _FundingRateDetailScreenState extends State<FundingRateDetailScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to access context safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final instrument =
          ModalRoute.of(context)!.settings.arguments as InstrumentInfo;
      // Initial fetch
      context.read<FundingRateBloc>().add(FetchFundingRateHistory(
          category: 'linear', symbol: instrument.symbol));
      _startPolling(instrument);
    });
  }

  void _startPolling(InstrumentInfo instrument) {
    final refreshInterval =
        context.read<SettingsBloc>().state.refreshInterval;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: refreshInterval), (timer) {
      context.read<FundingRateBloc>().add(FetchFundingRateHistory(
          category: 'linear', symbol: instrument.symbol));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instrument =
        ModalRoute.of(context)!.settings.arguments as InstrumentInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(instrument.symbol),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          _startPolling(instrument);
        },
        child: BlocBuilder<FundingRateBloc, FundingRateState>(
          builder: (context, state) {
            if (state is FundingRateLoading && state.fundingRates.isEmpty) {
              return const LoadingWidget();
            }

            if (state is FundingRateError && state.fundingRates.isEmpty) {
              return ErrorDisplayWidget(
                errorMessage: state.message,
                onRetry: () {
                  context.read<FundingRateBloc>().add(FetchFundingRateHistory(
                      category: 'linear', symbol: instrument.symbol));
                },
              );
            }

            if (state.fundingRates.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is FundingRateLoading)
                    const LinearProgressIndicator(),
                  Text(
                      'Last funding rate: ${state.fundingRates.first.fundingRate}'),
                  if (state is FundingRateError)
                    Text('Error: ${state.message}',
                        style: const TextStyle(color: Colors.red)),
                  Expanded(
                    child: FundingRateChart(
                        fundingRateHistory: state.fundingRates,
                        instrument: instrument),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}