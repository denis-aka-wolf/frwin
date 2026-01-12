import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:frwin/providers/funding_rate/funding_rate_bloc.dart';
import 'package:frwin/providers/funding_rate/funding_rate_event.dart';
import 'package:frwin/providers/funding_rate/funding_rate_state.dart';
import 'package:frwin/providers/settings/settings_bloc.dart';
import 'package:frwin/providers/settings/settings_state.dart';
import 'package:frwin/widgets/funding_rate_chart.dart';
import 'package:frwin/widgets/loading_widget.dart';
import 'package:frwin/app/core/di/di_container.dart';

class InstrumentDataCard extends StatelessWidget {
  final InstrumentInfo instrument;

  const InstrumentDataCard({super.key, required this.instrument});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FundingRateBloc>()
        ..add(FetchFundingRateHistory(
            category: 'linear', symbol: instrument.symbol)),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instrument.symbol,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return SizedBox(
                    height: settingsState.cardHeight,
                    child: BlocBuilder<FundingRateBloc, FundingRateState>(
                        builder: (context, state) {
                      if (state is FundingRateLoading &&
                          state.fundingRates.isEmpty) {
                      return const LoadingWidget();
                      } else if (state.fundingRates.isNotEmpty) {
                        return FundingRateChart(
                            fundingRateHistory: state.fundingRates);
                      } else if (state is FundingRateError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const Center(child: Text('No data'));
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}