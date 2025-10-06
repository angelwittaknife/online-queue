import 'package:online_queue/src/queue/data/models/queue_model.dart';

class QueueEntity {
  final String nickname;
  final int numInQueue;
  final String userId;

  const QueueEntity(this.nickname, this.numInQueue, this.userId);

  factory QueueEntity.fromModel(QueueModel queue) {
    return QueueEntity(queue.nickname, queue.numInQueue, queue.userId);
  }
}
