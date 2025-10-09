import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

class AddQueueParams {
  final QueueEntity first;
  final String second;

  AddQueueParams({required this.first, required this.second});
}
