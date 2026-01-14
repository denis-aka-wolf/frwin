import 'package:equatable/equatable.dart';

abstract class InstrumentEvent extends Equatable {
  const InstrumentEvent();

  @override
  List<Object> get props => [];
}

class FetchInstruments extends InstrumentEvent {
  final String category;

  const FetchInstruments({required this.category});

  @override
  List<Object> get props => [category];
}

class FetchMoreInstruments extends InstrumentEvent {
  final String category;

  const FetchMoreInstruments({required this.category});

  @override
  List<Object> get props => [category];
}

class FilterInstruments extends InstrumentEvent {
  final String? symbol;
  final int? fundingInterval;

  const FilterInstruments({this.symbol, this.fundingInterval});

  @override
  List<Object> get props => [symbol ?? '', fundingInterval ?? 0];
}

class ResetFilter extends InstrumentEvent {}