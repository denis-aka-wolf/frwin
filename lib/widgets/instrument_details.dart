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
        Text('Base: ${instrument.baseCurrency}'),
        Text('Quote: ${instrument.quoteCurrency}'),
      ],
    );
  }
}