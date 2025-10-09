import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class GetCurrentUidUsecase extends UseCase<Future<Either<Failure, String>>, void> {
  final AuthRepository repository;

  const GetCurrentUidUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call({param}) => repository.getCurrentUid();
}
