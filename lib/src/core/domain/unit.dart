/// A type with exactly one value, [unit], used where a use case has no
/// params or no meaningful result.
///
/// ```dart
/// class ClearAllRequests implements UseCaseBase<Unit, Unit> {
///   @override
///   Future<Unit> call(Unit params) async {
///     // …
///     return unit;
///   }
/// }
///
/// await clearAllRequests(unit);
/// ```
final class Unit {
  const Unit._();

  @override
  String toString() => '()';
}

/// The only [Unit] value.
const Unit unit = Unit._();
