sealed class Result<T, E> {
  const Result();
}

final class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

final class Error<T, E> extends Result<T, E> {
  final E failure;
  const Error(this.failure);
}
