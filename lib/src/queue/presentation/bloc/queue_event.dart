import 'package:equatable/equatable.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

abstract class QueueEvent extends Equatable {
  const QueueEvent();

  @override
  List<Object?> get props => [];
}

class LoadQueueByLab extends QueueEvent {
  final String labId;
  const LoadQueueByLab(this.labId);

  @override
  List<Object?> get props => [labId];
}

class AddQueueItem extends QueueEvent {
  final QueueEntity item;
  final String labId;
  const AddQueueItem({required this.item, required this.labId});

  @override
  List<Object?> get props => [item, labId];
}
class TryAddSlot extends QueueEvent {
  final int slotNumber;
  final String labId;
  const TryAddSlot({required this.slotNumber, required this.labId});
}
