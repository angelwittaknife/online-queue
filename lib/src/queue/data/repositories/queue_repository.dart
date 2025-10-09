import 'package:dartz/dartz.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/queue/data/datasources/queue_remote_datasource.dart';
import 'package:online_queue/src/queue/data/models/queue_model.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  final datasource = sl<QueueRemoteDatasource>();

  @override
  Stream<Either<Failure, List<QueueEntity>>> getQueueByLab(String labId) {
    return datasource.getQueueStreamById(labId).map((result) {
      return result.fold(
        Left.new,
        (models) => Right(models.map(QueueEntity.fromModel).toList()),
      );
    });
  }

  @override
  Future<Either<Failure, bool>> addQueue(
    QueueEntity queue,
    String labId,
  ) async {
    final result = await datasource.addQueue(
      QueueModel.fromEntity(queue),
      labId,
    );

    return result.fold(Left.new, Right.new);
  }
}
