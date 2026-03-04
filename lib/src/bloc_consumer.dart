import 'package:jaspr_bloc/jaspr_bloc.dart';

/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
///
/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listenWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   buildWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to rebuild the widget with state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
class BlocConsumer<B extends BlocBase<S>, S> extends StatefulComponent {
  const BlocConsumer({
    required this.builder,
    required this.listener,
    super.key,
    this.bloc,
    this.buildWhen,
    this.listenWhen,
  });

  /// The [bloc] that the [BlocConsumer] will interact with.
  /// If omitted, [BlocConsumer] will automatically perform a lookup using
  /// `BlocProvider` and the current `BuildContext`.
  final B? bloc;

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `state` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocComponentBuilder<S> builder;

  /// Takes the `BuildContext` along with the [bloc] `state`
  /// and is responsible for executing in response to `state` changes.
  final BlocComponentListener<S> listener;

  /// Takes the previous `state` and the current `state` and is responsible for
  /// returning a [bool] which determines whether or not to trigger
  /// [builder] with the current `state`.
  final BlocBuilderCondition<S>? buildWhen;

  /// Takes the previous `state` and the current `state` and is responsible for
  /// returning a [bool] which determines whether or not to call [listener] of
  /// [BlocConsumer] with the current `state`.
  final BlocListenerCondition<S>? listenWhen;

  @override
  State<BlocConsumer<B, S>> createState() => _BlocConsumerState<B, S>();
}

class _BlocConsumerState<B extends BlocBase<S>, S>
    extends State<BlocConsumer<B, S>> {
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = component.bloc ?? BlocProvider.of<B>(context);
  }

  @override
  void didUpdateComponent(BlocConsumer<B, S> oldComponent) {
    super.didUpdateComponent(oldComponent);
    final oldBloc = oldComponent.bloc ?? BlocProvider.of<B>(context);
    final currentBloc = oldComponent.bloc ?? oldBloc;
    if (oldBloc != currentBloc) _bloc = currentBloc;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = component.bloc ?? BlocProvider.of<B>(context);
    if (_bloc != bloc) _bloc = bloc;
  }

  @override
  Component build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: _bloc,
      builder: component.builder,
      buildWhen: (previous, current) {
        if (component.listenWhen?.call(previous, current) ?? true) {
          component.listener(context, current);
        }
        return component.buildWhen?.call(previous, current) ?? true;
      },
    );
  }
}
