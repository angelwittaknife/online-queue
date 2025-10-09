import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase extends UseCase<Future<Either<Failure, String>>, StudentEntity> {
  final AuthRepository repository;

  const RegisterUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call({param}) => repository.register(param!);
}
