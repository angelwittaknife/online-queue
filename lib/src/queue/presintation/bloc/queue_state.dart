import 'package:equatable/equatable.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

abstract class QueueState extends Equatable {
  const QueueState();

  @override
  List<Object?> get props => [];
}

class QueueInitial extends QueueState {}

class QueueLoadInProgress extends QueueState {}

class QueueLoadSuccess extends QueueState {
  final List<QueueEntity> queue;
  const QueueLoadSuccess(this.queue);

  @override
  List<Object?> get props => [queue];
}

class QueueLoadFailure extends QueueState {
  final String message;
  const QueueLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
