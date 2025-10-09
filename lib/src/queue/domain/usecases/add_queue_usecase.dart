import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';
import 'package:online_queue/src/queue/domain/usecases/add_queue_params.dart';

class AddQueueUsecase extends UseCase<Future<Either<Failure,bool>>,AddQueueParams> {
  final QueueRepository repository;

  const AddQueueUsecase(this.repository);
  
  @override
  Future<Either<Failure,bool>> call({param}) => repository.addQueue(param!.first,param.second);
}
