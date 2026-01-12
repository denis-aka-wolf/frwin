import 'package:equatable/equatable.dart';
import 'package:frwin/models/funding_rate_data.dart';

abstract class FundingRateState extends Equatable {
  final List<FundingRateData> fundingRates;

  const FundingRateState({this.fundingRates = const []});

  @override
  List<Object> get props => [fundingRates];
}

class FundingRateInitial extends FundingRateState {}

class FundingRateLoading extends FundingRateState {
  const FundingRateLoading({List<FundingRateData> fundingRates = const []})
      : super(fundingRates: fundingRates);
}

class FundingRateLoaded extends FundingRateState {
  const FundingRateLoaded({required List<FundingRateData> fundingRates})
      : super(fundingRates: fundingRates);
}

class FundingRateError extends FundingRateState {
  final String message;

  const FundingRateError(
      {required this.message, List<FundingRateData> fundingRates = const []})
      : super(fundingRates: fundingRates);

  @override
  List<Object> get props => [message, fundingRates];
}