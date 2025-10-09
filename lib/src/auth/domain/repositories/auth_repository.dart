import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> register(StudentEntity student);

  Future<Either<Failure, String>> signIn(String email, String password);

  Future<Either<Failure, bool>> signOut();

  Future<Either<Failure, StudentEntity>> getProfile(String uid);

  Future<Either<Failure, bool>> updateNickname(String uid, String newNickname);

  Future<Either<Failure, String>> getCurrentUid();
}
