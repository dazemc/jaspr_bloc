import 'package:jaspr/jaspr.dart';

abstract class SingleChildComponent extends StatefulComponent {
  final Component? child;
  const SingleChildComponent({super.key, this.child});
}

class SingleChildState<T extends SingleChildComponent> extends State<T> {
  @override
  Component build(BuildContext context) {
    // Return the child or wrap it
    return component.child ?? const Component.text('No child');
  }
}
