import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

class QueueModel {
  final String nickname;
  final int numInQueue;
  final String userId;

  QueueModel(this.nickname, this.numInQueue, this.userId);

  Map<String, dynamic> toMap() {
    return {'nickname': nickname, 'numInQueue': numInQueue, "userId": userId};
  }

  factory QueueModel.fromMap(String id, Map<String, dynamic> map) {
    return QueueModel(
      map['nickname'] as String? ?? '',
      map['numInQueue'] as int? ?? 0,
      map['userId'] as String? ?? '',
    );
  }

  factory QueueModel.fromEntity(QueueEntity queue) {
    return QueueModel(queue.nickname, queue.numInQueue, queue.userId);
  }
  
}
