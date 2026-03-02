import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_bloc_example/bloc/counter_bloc.dart';
import 'package:jaspr_bloc/jaspr_bloc.dart';

import '../constants/theme.dart';

class Counter extends StatefulComponent {
  const Counter({super.key});

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  late final CounterBloc bloc;
  late final StreamSubscription sub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProvider.of<CounterBloc>(context);
    sub = bloc.stream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div([
      div(classes: 'counter', [
        button(
          onClick: () {
            bloc.add(CounterDecrementPressed());
          },
          [.text('-')],
        ),
        span([.text('${bloc.state.counter}')]),
        button(
          onClick: () {
            bloc.add(CounterIncrementPressed());
          },
          [.text('+')],
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.counter', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(vertical: 10.px),
        border: .symmetric(
          vertical: .solid(color: primaryColor, width: 2.px),
        ),
        alignItems: .center,
      ),
      css('button', [
        css('&').styles(
          display: .flex,
          width: 2.em,
          height: 2.em,
          border: .unset,
          radius: .all(.circular(2.em)),
          cursor: .pointer,
          justifyContent: .center,
          alignItems: .center,
          fontSize: 2.rem,
          backgroundColor: Colors.transparent,
        ),
        css('&:hover').styles(
          backgroundColor: const Color('#0001'),
        ),
      ]),
      css('span').styles(
        minWidth: 2.5.em,
        padding: .symmetric(horizontal: 2.rem),
        boxSizing: .borderBox,
        color: primaryColor,
        textAlign: .center,
        fontSize: 4.rem,
      ),
    ]),
  ];
}
