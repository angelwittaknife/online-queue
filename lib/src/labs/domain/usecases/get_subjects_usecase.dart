import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/labs/domain/entities/subject_entity.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';

class GetSubjectsUsecase extends UseCase<List<SubjectEntity>, void> {
  final LabRepository repository;

  const GetSubjectsUsecase(this.repository);
  
  @override
  Future<Either<Failure, List<SubjectEntity>>> call({param}) => repository.getAllSubjects();
}
