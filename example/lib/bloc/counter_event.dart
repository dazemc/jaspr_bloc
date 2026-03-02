part of 'counter_bloc.dart';

sealed class CounterEvent {
  const CounterEvent();
}

final class CounterIncrementPressed extends CounterEvent {}

final class CounterDecrementPressed extends CounterEvent {}
