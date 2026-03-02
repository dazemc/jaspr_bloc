import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterValueState(counter: 0)) {
    print('Hello bloc');
    on<CounterIncrementPressed>(incrementCounter);
    on<CounterDecrementPressed>(decrementCounter);
  }

  void incrementCounter(CounterIncrementPressed event, Emitter<CounterState> emit) =>
      emit(CounterValueState(counter: state.counter + 1));

  void decrementCounter(CounterDecrementPressed event, Emitter<CounterState> emit) =>
      emit(CounterValueState(counter: state.counter - 1));
}
