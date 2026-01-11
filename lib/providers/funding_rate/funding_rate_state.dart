import 'package:equatable/equatable.dart';
import 'package:frwin/models/funding_rate_data.dart';

abstract class FundingRateState extends Equatable {
  const FundingRateState();

  @override
  List<Object> get props => [];
}

class FundingRateInitial extends FundingRateState {}

class FundingRateLoading extends FundingRateState {}

class FundingRateLoaded extends FundingRateState {
  final List<FundingRateData> fundingRates;

  const FundingRateLoaded({required this.fundingRates});

  @override
  List<Object> get props => [fundingRates];
}

class FundingRateError extends FundingRateState {
  final String message;

  const FundingRateError({required this.message});

  @override
  List<Object> get props => [message];
}