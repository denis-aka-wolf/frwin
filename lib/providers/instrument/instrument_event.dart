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