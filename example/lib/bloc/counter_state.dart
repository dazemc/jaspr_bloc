part of 'counter_bloc.dart';

sealed class CounterState extends Equatable {
  final int counter;
  const CounterState({required this.counter});

  @override
  List<Object?> get props => [counter];
}

final class CounterValueState extends CounterState {
  const CounterValueState({required super.counter});
}
