import 'package:equatable/equatable.dart';

abstract class FundingRateEvent extends Equatable {
  const FundingRateEvent();

  @override
  List<Object> get props => [];
}

class FetchFundingRateHistory extends FundingRateEvent {
  final String category;
  final String symbol;

  const FetchFundingRateHistory({required this.category, required this.symbol});

  @override
  List<Object> get props => [category, symbol];
}