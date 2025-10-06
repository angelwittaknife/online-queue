import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

abstract interface class QueueRepository {
  Stream<Either<Failure, List<QueueEntity>>> getQueueByLab(String labId);
  Future<Either<Failure,List<QueueEntity>>> addQueue(QueueEntity queue,String labId);
}