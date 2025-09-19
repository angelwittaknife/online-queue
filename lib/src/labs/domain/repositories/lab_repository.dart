import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';

abstract interface class LabRepository{
  Future<Either<Failure,List<LabEntity>>> getLabs();
  Future<Either<Failure,Unit>> addLab(LabEntity lab);
  Future<Either<Failure,Unit>> closeLab(int id);
}