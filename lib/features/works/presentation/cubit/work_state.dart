import '../../domain/entities/work.dart';

sealed class WorkState {
  const WorkState();
}

final class WorkInitial extends WorkState {
  const WorkInitial();
}

final class WorkLoading extends WorkState {
  const WorkLoading();
}

final class WorkLoaded extends WorkState {
  final List<Work> works;
  const WorkLoaded(this.works);
}

final class WorkError extends WorkState {
  final String message;
  const WorkError(this.message);
}
