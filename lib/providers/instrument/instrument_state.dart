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
  final String? nextCursor;
  final bool hasMore;

  const InstrumentLoaded({
    required this.instruments,
    this.nextCursor,
    this.hasMore = false,
  });

  InstrumentLoaded copyWith({
    List<InstrumentInfo>? instruments,
    String? nextCursor,
    bool? hasMore,
  }) {
    return InstrumentLoaded(
      instruments: instruments ?? this.instruments,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object> get props => [instruments, nextCursor ?? '', hasMore];
}

class InstrumentError extends InstrumentState {
  final String message;

  const InstrumentError({required this.message});

  @override
  List<Object> get props => [message];
}