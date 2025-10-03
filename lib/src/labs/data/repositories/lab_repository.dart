import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/labs/data/datasources/lab_remote_datasource.dart';
import 'package:online_queue/src/labs/data/models/lab_model.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';
import 'package:online_queue/src/labs/domain/entities/subject_entity.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';

class LabRepositoryImpl implements LabRepository {
  final datasource = sl<LabRemoteDatasource>();
  @override
  Future<Either<Failure, Unit>> addLab(LabEntity lab) async {
    final result = await datasource.addLab(LabModel.fromEntity(lab));
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, Unit>> closeLab(String id) async {
    final result = await datasource.deleteLab(id);
    return result.fold(Left.new, Right.new);
  }

  
  @override
  Future<Either<Failure, LabEntity>> getLabById(String id) async {
    final result = await datasource.getLabById(id);
    return result.fold(Left.new, (data) => Right(LabEntity.fromModel(data)));
  }

  @override
  Future<Either<Failure, List<LabEntity>>> getLabs() async {
    final result = await datasource.getAllLabs();
    return result.fold(
      Left.new,
      (data) => Right(data.map((e) => (LabEntity.fromModel(e))).toList()),
    );
  }
  
  @override
  Future<Either<Failure, List<LabEntity>>> getLabsBySubject(String subject) async {
    final result = await datasource.getLabsBySubject(subject);
    return result.fold(
      Left.new,
      (data) => Right(data.map((e) => (LabEntity.fromModel(e))).toList()),
    );
  }
  
  @override
  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects() async {
    final result = await datasource.getAllSubjects();
    return result.fold(
      Left.new,
      (data) => Right(data.map((e) => (SubjectEntity.fromModel(e))).toList()),
    );
  }
}
