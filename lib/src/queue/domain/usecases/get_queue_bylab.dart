import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';

class GetQueueByLabUsecase extends UseCase<Stream<Either<Failure, List<QueueEntity>>>, String> {
  final QueueRepository repository;

  const GetQueueByLabUsecase(this.repository);
  
  @override
  Stream<Either<Failure, List<QueueEntity>>> call({param}) => repository.getQueueByLab(param!);
}
