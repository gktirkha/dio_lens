import 'dart:async';

abstract interface class UseCaseBase<R, P> {
  FutureOr<R> call(P params);
}
