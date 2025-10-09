import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/usecase/usecase.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class UpdateNicknameUsecase extends UseCase<Future<Either<Failure, bool>>, UpdateNicknameParams> {
  final AuthRepository repository;

  const UpdateNicknameUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call({param}) =>
      repository.updateNickname(param!.uid, param.newNickname);
}


class UpdateNicknameParams {
  final String uid;
  final String newNickname;

  UpdateNicknameParams({required this.uid, required this.newNickname});
}
