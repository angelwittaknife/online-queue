import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';

class GetLabUsecase extends UseCase<Future<Either<Failure,LabEntity>>, String> {
  final LabRepository repository;

  const GetLabUsecase(this.repository);
  
  @override
  Future<Either<Failure, LabEntity>> call({param}) => repository.getLabById(param!);
}
