import 'dart:async';

/// One unit of business logic: takes [P] and returns [R]. Use [Unit] when there
/// are no parameters or no result.
abstract interface class UseCaseBase<R, P> {
  /// Runs the use case with [params].
  FutureOr<R> call(P params);
}
