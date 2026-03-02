import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';

class BlocProvider<T extends BlocBase<Object?>> extends StatefulComponent {
  final T bloc;
  final Component child;
  const BlocProvider({
    required this.bloc,
    required this.child,
  });

  @override
  State<BlocProvider<T>> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase<Object?>>(BuildContext context) {
    final inherited = context.dependOnInheritedComponentOfExactType<_BlocInherited<T>>();
    if (inherited == null) {
      throw Exception('No BlocProvider<$T> found in context');
    }
    return inherited.bloc;
  }
}

class _BlocProviderState<T extends BlocBase<Object?>> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    component.bloc.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return _BlocInherited<T>(
      bloc: component.bloc,
      child: component.child,
    );
  }
}

class _BlocInherited<T extends BlocBase<Object?>> extends InheritedComponent {
  final T bloc;
  const _BlocInherited({required this.bloc, required super.child});

  @override
  bool updateShouldNotify(_) => false;
}
