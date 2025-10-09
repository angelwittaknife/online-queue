import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:online_queue/src/auth/data/models/student_model.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource = sl<AuthRemoteDatasource>();

  @override
  Future<Either<Failure, String>> register(StudentEntity student) async {

    final model = StudentModel.fromEntity(student);
    final result = await datasource.register(model);
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, String>> signIn(String email, String password) async {
    final result = await datasource.signIn(email, password);
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    final result = await datasource.signOut();
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, StudentEntity>> getProfile(String uid) async {
    final result = await datasource.getProfile(uid);
    return result.fold(
      Left.new,
      (model) => Right(StudentEntity.fromModel(model)),
    );
  }

  @override
  Future<Either<Failure, bool>> updateNickname(String uid, String newNickname) async {
    final result = await datasource.updateNickname(uid, newNickname);
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<Either<Failure, String>> getCurrentUid() async {
    final result = await datasource.getCurrentUid();
    return result.fold(Left.new, Right.new);
  }
}
