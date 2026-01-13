import 'package:flutter/material.dart';
import 'package:frwin/models/instrument_info.dart';

class InstrumentDetails extends StatelessWidget {
  final InstrumentInfo instrument;

  const InstrumentDetails({super.key, required this.instrument});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symbol: ${instrument.symbol}'),
        Text('Status: ${instrument.status}'),
        Text('Base Coin: ${instrument.baseCoin}'),
        Text('Quote Coin: ${instrument.quoteCoin}'),
        Text('Settle Coin: ${instrument.settleCoin}'),
        Text('Funding Interval: ${instrument.fundingInterval}'),
        Text('Copy Trading: ${instrument.copyTrading}'),
        Text('Upper Funding Rate: ${instrument.upperFundingRate}'),
        Text('Lower Funding Rate: ${instrument.lowerFundingRate}'),
      ],
    );
  }
}