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
  final List<InstrumentInfo> filteredInstruments;
  final String? nextCursor;
  final bool hasMore;
  final String? symbolFilter;
  final int? fundingIntervalFilter;

  const InstrumentLoaded({
    required this.instruments,
    required this.filteredInstruments,
    this.nextCursor,
    this.hasMore = false,
    this.symbolFilter,
    this.fundingIntervalFilter,
  });

  InstrumentLoaded copyWith({
    List<InstrumentInfo>? instruments,
    List<InstrumentInfo>? filteredInstruments,
    String? nextCursor,
    bool? hasMore,
    String? symbolFilter,
    int? fundingIntervalFilter,
  }) {
    return InstrumentLoaded(
      instruments: instruments ?? this.instruments,
      filteredInstruments: filteredInstruments ?? this.filteredInstruments,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      symbolFilter: symbolFilter ?? this.symbolFilter,
      fundingIntervalFilter: fundingIntervalFilter ?? this.fundingIntervalFilter,
    );
  }

  @override
  List<Object> get props => [
        instruments,
        filteredInstruments,
        nextCursor ?? '',
        hasMore,
        symbolFilter ?? '',
        fundingIntervalFilter ?? 0,
      ];
}

class InstrumentError extends InstrumentState {
  final String message;

  const InstrumentError({required this.message});

  @override
  List<Object> get props => [message];
}