import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frwin/services/bybit_api_service.dart';
import 'package:frwin/providers/instrument/instrument_event.dart';
import 'package:frwin/providers/instrument/instrument_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  final BybitApiService _bybitApiService;

  InstrumentBloc(this._bybitApiService) : super(InstrumentInitial()) {
    on<FetchInstruments>(_onFetchInstruments);
    on<FetchMoreInstruments>(_onFetchMoreInstruments);
  }

  void _onFetchInstruments(
      FetchInstruments event, Emitter<InstrumentState> emit) async {
    emit(InstrumentLoading());
    try {
      final response =
          await _bybitApiService.getInstrumentsInfo(event.category);
      emit(InstrumentLoaded(
        instruments: response.list,
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
        emit(currentState.copyWith(
          instruments: currentState.instruments + response.list,
          nextCursor: response.nextPageCursor,
          hasMore: response.nextPageCursor != null && response.nextPageCursor!.isNotEmpty,
        ));
      } catch (e) {
        // Optionally handle error for fetching more
      }
    }
  }
}