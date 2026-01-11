import 'package:equatable/equatable.dart';
import 'package:frwin/models/instrument_info.dart';

abstract class InstrumentState extends Equatable {
  const InstrumentState();

  @override
  List<Object> get props => [];
}

class InstrumentInitial extends InstrumentState {}

class InstrumentLoading extends InstrumentState {}

class InstrumentLoaded extends InstrumentState {
  final List<InstrumentInfo> instruments;

  const InstrumentLoaded({required this.instruments});

  @override
  List<Object> get props => [instruments];
}

class InstrumentError extends InstrumentState {
  final String message;

  const InstrumentError({required this.message});

  @override
  List<Object> get props => [message];
}