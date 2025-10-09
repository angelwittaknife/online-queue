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
  final bool isAdding;
  final int? addingSlot;
  final bool recentlyAdded;

  const QueueLoadSuccess(
    this.queue, {
    this.isAdding = false,
    this.addingSlot,
    this.recentlyAdded = false,
  });

  QueueLoadSuccess copyWith({
    List<QueueEntity>? queue,
    bool? isAdding,
    int? addingSlot,
    bool? recentlyAdded,
  }) {
    return QueueLoadSuccess(
      queue ?? this.queue,
      isAdding: isAdding ?? this.isAdding,
      addingSlot: addingSlot ?? this.addingSlot,
      recentlyAdded: recentlyAdded ?? this.recentlyAdded,
    );
  }

  @override
  List<Object?> get props => [queue, isAdding, addingSlot, recentlyAdded];
}

class QueueLoadFailure extends QueueState {
  final String message;
  const QueueLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
