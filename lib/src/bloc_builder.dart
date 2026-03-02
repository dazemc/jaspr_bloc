import 'dart:async';

import 'package:jaspr_bloc/jaspr_bloc.dart';

typedef BlocComponentBuilder<S> =
    Component Function(BuildContext context, S state);
typedef BlocBuilderCondition<S> = bool Function(S previous, S current);

class BlocBuilder<B extends BlocBase<S>, S> extends BlocBuilderBase<B, S> {
  final BlocComponentBuilder<S> builder;
  const BlocBuilder({
    super.key,
    super.bloc,
    super.buildWhen,
    required this.builder,
  });

  @override
  Component build(BuildContext context, S state) => builder(context, state);
}

abstract class BlocBuilderBase<B extends BlocBase<S>, S>
    extends StatefulComponent {
  final B? bloc;
  final BlocBuilderCondition<S>? buildWhen;
  const BlocBuilderBase({super.key, this.bloc, this.buildWhen});

  Component build(BuildContext context, S state);

  @override
  State<StatefulComponent> createState() => _BlocBuilderBaseState<B, S>();
}

class _BlocBuilderBaseState<B extends BlocBase<S>, S>
    extends State<BlocBuilderBase<B, S>> {
  late B _bloc;
  late S _state;
  StreamSubscription<S>? _subscription;

  @override
  void initState() {
    super.initState();
    _initializeBloc();
  }

  void _initializeBloc() {
    _bloc = component.bloc ?? BlocProvider.of<B>(context);
    _state = _bloc.state;

    _subscription?.cancel();
    _subscription = _bloc.stream.listen((newState) {
      final shouldBuild = component.buildWhen?.call(_state, newState) ?? true;

      shouldBuild ? setState(() => _state = newState) : _state = newState;
    });
  }

  @override
  void didUpdateComponent(BlocBuilderBase<B, S> oldComponent) {
    super.didUpdateComponent(oldComponent);
    final oldBloc = oldComponent.bloc ?? _bloc;
    final currentBloc = component.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = _bloc.state;
      _initializeBloc();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeBloc();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) => component.build(context, _state);
}
