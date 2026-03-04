import 'package:jaspr_bloc/jaspr_bloc.dart';

typedef BlocComponentListener<S> = void Function(BuildContext context, S state);
typedef BlocListenerCondition<S> = bool Function(S previous, S current);

class BlocListener<B extends BlocBase<S>, S> extends BlocListenerBase<B, S> {
  const BlocListener({
    required super.listener,
    super.key,
    super.bloc,
    super.listenWhen,
    super.child,
  });
}

abstract class BlocListenerBase<B extends BlocBase<S>, S>
    extends SingleChildComponent {
  const BlocListenerBase({
    required this.listener,
    super.key,
    this.bloc,
    this.listenWhen,
    super.child,
  });

  final B? bloc;
  final BlocComponentListener<S> listener;
  final BlocListenerCondition<S>? listenWhen;

  @override
  State<BlocListenerBase<B, S>> createState() => _BlocListenerBaseState<B, S>();
}

class _BlocListenerBaseState<B extends BlocBase<S>, S>
    extends SingleChildState<BlocListenerBase<B, S>> {
  late B _bloc;
  late S _previousState;
  StreamSubscription<S>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = component.bloc ?? BlocProvider.of<B>(context);
    _previousState = _bloc.state;
    _subscribe();
  }

  @override
  void didUpdateComponent(BlocListenerBase<B, S> oldComponent) {
    super.didUpdateComponent(oldComponent);
    final oldBloc = oldComponent.bloc ?? _bloc;
    final currentBloc = component.bloc ?? oldBloc;
    if (_bloc != currentBloc) {
      _unsubscribe();
      _bloc = currentBloc;
      _previousState = _bloc.state;
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = component.bloc ?? BlocProvider.of<B>(context);
    if (_bloc != bloc) {
      _unsubscribe();
      _bloc = bloc;
      _previousState = _bloc.state;
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = _bloc.stream.listen((state) {
      if (!mounted) return;
      if (component.listenWhen?.call(_previousState, state) ?? true) {
        component.listener(context, state);
      }
      _previousState = state;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Component build(BuildContext context) =>
      component.child ?? const Component.text('');
}
