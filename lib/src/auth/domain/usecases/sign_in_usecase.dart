import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class SignInUsecase extends UseCase<Future<Either<Failure, String>>, SignInParams> {
  final AuthRepository repository;

  const SignInUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call({param}) =>
      repository.signIn(param!.email, param.password);
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
