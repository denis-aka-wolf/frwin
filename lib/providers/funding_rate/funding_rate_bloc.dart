import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/services/funding_rate_repository.dart';
import 'package:frwin/providers/funding_rate/funding_rate_event.dart';
import 'package:frwin/providers/funding_rate/funding_rate_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class FundingRateBloc extends Bloc<FundingRateEvent, FundingRateState> {
  final FundingRateRepository _fundingRateRepository;

  FundingRateBloc(this._fundingRateRepository) : super(FundingRateInitial()) {
    on<FetchFundingRateHistory>(_onFetchFundingRateHistory);
  }

  void _onFetchFundingRateHistory(
      FetchFundingRateHistory event, Emitter<FundingRateState> emit) async {
    // Emit loading state but preserve old data
    emit(FundingRateLoading(fundingRates: state.fundingRates));
    try {
      final fundingRates = await _fundingRateRepository.getFundingRateHistory(
          event.category, event.symbol);
      emit(FundingRateLoaded(fundingRates: fundingRates));
    } catch (e) {
      // Emit error state but preserve old data
      emit(FundingRateError(
          message: e.toString(), fundingRates: state.fundingRates));
    }
  }
}