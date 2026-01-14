import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/services/bybit_api_service.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:frwin/providers/instrument/instrument_event.dart';
import 'package:frwin/providers/instrument/instrument_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  final BybitApiService _bybitApiService;

  InstrumentBloc(this._bybitApiService) : super(InstrumentInitial()) {
    on<FetchInstruments>(_onFetchInstruments);
    on<FetchMoreInstruments>(_onFetchMoreInstruments);
    on<FilterInstruments>(_onFilterInstruments);
    on<ResetFilter>(_onResetFilter);
  }

  void _onFetchInstruments(
      FetchInstruments event, Emitter<InstrumentState> emit) async {
    emit(InstrumentLoading());
    try {
      final response =
          await _bybitApiService.getInstrumentsInfo(event.category);
      emit(InstrumentLoaded(
        instruments: response.list,
        filteredInstruments: response.list,
        nextCursor: response.nextPageCursor,
        hasMore: response.nextPageCursor != null && response.nextPageCursor!.isNotEmpty,
      ));
    } catch (e) {
      emit(InstrumentError(message: e.toString()));
    }
  }

  void _onFetchMoreInstruments(
      FetchMoreInstruments event, Emitter<InstrumentState> emit) async {
    if (state is InstrumentLoaded) {
      final currentState = state as InstrumentLoaded;
      if (!currentState.hasMore) return;

      try {
        final response = await _bybitApiService.getInstrumentsInfo(
          event.category,
          cursor: currentState.nextCursor,
        );
        final newInstruments = currentState.instruments + response.list;
        List<InstrumentInfo> filteredList = List.from(newInstruments);

        if (currentState.symbolFilter != null &&
            currentState.symbolFilter!.isNotEmpty) {
          filteredList = filteredList
              .where((instrument) => instrument.symbol
                  .toLowerCase()
                  .contains(currentState.symbolFilter!.toLowerCase()))
              .toList();
        }

        if (currentState.fundingIntervalFilter != null) {
          filteredList = filteredList
              .where((instrument) =>
                  instrument.fundingInterval ==
                  currentState.fundingIntervalFilter)
              .toList();
        }

        emit(currentState.copyWith(
          instruments: newInstruments,
          filteredInstruments: filteredList,
          nextCursor: response.nextPageCursor,
          hasMore: response.nextPageCursor != null &&
              response.nextPageCursor!.isNotEmpty,
        ));
      } catch (e) {
        // Optionally handle error for fetching more
      }
    }
  }

  void _onFilterInstruments(
      FilterInstruments event, Emitter<InstrumentState> emit) {
    if (state is InstrumentLoaded) {
      final currentState = state as InstrumentLoaded;
      List<InstrumentInfo> filteredList = List.from(currentState.instruments);

      if (event.symbol != null && event.symbol!.isNotEmpty) {
        filteredList = filteredList
            .where((instrument) =>
                instrument.symbol.toLowerCase().contains(event.symbol!.toLowerCase()))
            .toList();
      }

      if (event.fundingInterval != null) {
        filteredList = filteredList
            .where((instrument) =>
                instrument.fundingInterval == event.fundingInterval)
            .toList();
      }

      emit(currentState.copyWith(
        filteredInstruments: filteredList,
        symbolFilter: event.symbol,
        fundingIntervalFilter: event.fundingInterval,
      ));
    }
  }

  void _onResetFilter(ResetFilter event, Emitter<InstrumentState> emit) {
    if (state is InstrumentLoaded) {
      final currentState = state as InstrumentLoaded;
      emit(currentState.copyWith(
        filteredInstruments: currentState.instruments,
        symbolFilter: '',
        fundingIntervalFilter: null,
      ));
    }
  }
}