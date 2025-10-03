import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';

class CloseLabUsecase extends UseCase<Unit, String> {
  final LabRepository repository;

  const CloseLabUsecase(this.repository);
  
  @override
  Future<Either<Failure, Unit>> call({param}) => repository.closeLab(param!);
}
