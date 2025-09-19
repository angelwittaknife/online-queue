import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';

class GetLabsUsecase extends UseCase<Unit, LabEntity> {
  final LabRepository repository;

  const GetLabsUsecase(this.repository);
  
  @override
  Future<Either<Failure, Unit>> call({param}) => repository.addLab(param!);
}
