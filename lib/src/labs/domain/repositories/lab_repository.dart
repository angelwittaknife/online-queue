import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';
import 'package:online_queue/src/labs/domain/entities/subject_entity.dart';

abstract interface class LabRepository{
  Future<Either<Failure,List<LabEntity>>> getLabs();
  Future<Either<Failure,Unit>> addLab(LabEntity lab);
  Future<Either<Failure,LabEntity>> getLabById(String id);
  Future<Either<Failure,Unit>> closeLab(String id);
  Future<Either<Failure,List<LabEntity>>> getLabsBySubject(String subject);
  Future<Either<Failure,List<SubjectEntity>>> getAllSubjects();

}