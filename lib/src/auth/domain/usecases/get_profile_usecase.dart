import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class GetProfileUsecase extends UseCase<Future<Either<Failure, StudentEntity>>, String> {
  final AuthRepository repository;

  const GetProfileUsecase(this.repository);

  @override
  Future<Either<Failure, StudentEntity>> call({param}) => repository.getProfile(param!);
}
