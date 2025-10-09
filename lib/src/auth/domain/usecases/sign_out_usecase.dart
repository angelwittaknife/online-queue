import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase extends UseCase<Future<Either<Failure, bool>>, void> {
  final AuthRepository repository;

  const SignOutUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call({param}) => repository.signOut();
}
