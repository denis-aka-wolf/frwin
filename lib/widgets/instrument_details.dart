import 'package:flutter/material.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:intl/intl.dart';

class InstrumentDetails extends StatelessWidget {
  final InstrumentInfo instrument;

  const InstrumentDetails({super.key, required this.instrument});

  @override
  Widget build(BuildContext context) {
    final launchTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(instrument.launchTime));
    final formattedLaunchTime = DateFormat.yMMMd().add_Hms().format(launchTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: 'The name of the trading pair.',
          child: Text('Symbol: ${instrument.symbol}'),
        ),
        Tooltip(
          message: 'The type of contract, e.g., LinearPerpetual.',
          child: Text('Contract Type: ${instrument.contractType}'),
        ),
        Tooltip(
          message:
              'The current trading status of the instrument (e.g., Trading, PreLaunch).',
          child: Text('Status: ${instrument.status}'),
        ),
        Tooltip(
          message: 'The time when the instrument was launched for trading.',
          child: Text('Launch Time: $formattedLaunchTime'),
        ),
        Tooltip(
          message:
              'The time of settlement for futures contracts (0 for perpetuals).',
          child: Text('Delivery Time: ${instrument.deliveryTime}'),
        ),
        Tooltip(
          message: 'The fee rate for contract delivery.',
          child: Text('Delivery Fee Rate: ${instrument.deliveryFeeRate}'),
        ),
        Tooltip(
          message:
              'The precision of the price, indicating the number of decimal places.',
          child: Text('Price Scale: ${instrument.priceScale}'),
        ),
        const SizedBox(height: 8),
        const Text('Leverage:', style: TextStyle(fontWeight: FontWeight.bold)),
        Tooltip(
          message: 'The minimum leverage allowed for this instrument.',
          child:
              Text('  Min Leverage: ${instrument.leverageFilter.minLeverage}'),
        ),
        Tooltip(
          message: 'The maximum leverage allowed for this instrument.',
          child:
              Text('  Max Leverage: ${instrument.leverageFilter.maxLeverage}'),
        ),
        Tooltip(
          message: 'The increment in which leverage can be adjusted.',
          child: Text(
              '  Leverage Step: ${instrument.leverageFilter.leverageStep}'),
        ),
        const SizedBox(height: 8),
        const Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
        Tooltip(
          message: 'The minimum price at which an order can be placed.',
          child: Text('  Min Price: ${instrument.priceFilter.minPrice}'),
        ),
        Tooltip(
          message: 'The maximum price at which an order can be placed.',
          child: Text('  Max Price: ${instrument.priceFilter.maxPrice}'),
        ),
        Tooltip(
          message: 'The smallest price movement of the instrument.',
          child: Text('  Tick Size: ${instrument.priceFilter.tickSize}'),
        ),
        const SizedBox(height: 8),
        const Text('Order Quantity:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Tooltip(
          message: 'The maximum quantity for a single order.',
          child:
              Text('  Max Order Qty: ${instrument.lotSizeFilter.maxOrderQty}'),
        ),
        Tooltip(
          message: 'The minimum quantity for a single order.',
          child:
              Text('  Min Order Qty: ${instrument.lotSizeFilter.minOrderQty}'),
        ),
        Tooltip(
          message: 'The increment for the order quantity.',
          child: Text('  Qty Step: ${instrument.lotSizeFilter.qtyStep}'),
        ),
        Tooltip(
          message: 'The maximum quantity for a post-only order (maker order).',
          child: Text(
              '  Post-Only Max Order Qty: ${instrument.lotSizeFilter.postOnlyMaxOrderQty}'),
        ),
        Tooltip(
          message: 'The maximum quantity for a single market order.',
          child: Text(
              '  Max Mkt Order Qty: ${instrument.lotSizeFilter.maxMktOrderQty}'),
        ),
        Tooltip(
          message:
              'The minimum notional value required for an order (Price * Quantity).',
          child: Text(
              '  Min Notional Value: ${instrument.lotSizeFilter.minNotionalValue}'),
        ),
        const SizedBox(height: 8),
        Tooltip(
          message: 'The asset being traded.',
          child: Text('Base Coin: ${instrument.baseCoin}'),
        ),
        Tooltip(
          message: 'The asset used to price the base coin.',
          child: Text('Quote Coin: ${instrument.quoteCoin}'),
        ),
        Tooltip(
          message: 'The asset used for settlement and calculating profit/loss.',
          child: Text('Settle Coin: ${instrument.settleCoin}'),
        ),
        Tooltip(
          message:
              'The time interval (in minutes) between funding fee payments.',
          child: Text('Funding Interval: ${instrument.fundingInterval}'),
        ),
        Tooltip(
          message: 'Indicates if the instrument is available for copy trading.',
          child: Text('Copy Trading: ${instrument.copyTrading}'),
        ),
        Tooltip(
          message: 'The maximum funding rate.',
          child: Text('Upper Funding Rate: ${instrument.upperFundingRate}'),
        ),
        Tooltip(
          message: 'The minimum funding rate.',
          child: Text('Lower Funding Rate: ${instrument.lowerFundingRate}'),
        ),
      ],
    );
  }
}
