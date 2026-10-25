/// A type with a single value, [unit], for use cases that take no parameters or
/// return nothing.
final class Unit {
  const Unit._();

  @override
  String toString() => '()';
}

/// The only [Unit] value.
const Unit unit = Unit._();
