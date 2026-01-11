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
  }

  void _onFetchInstruments(
      FetchInstruments event, Emitter<InstrumentState> emit) async {
    emit(InstrumentLoading());
    try {
      final instruments =
          await _bybitApiService.getInstrumentsInfo(event.category);
      emit(InstrumentLoaded(instruments: instruments));
    } catch (e) {
      emit(InstrumentError(message: e.toString()));
    }
  }
}