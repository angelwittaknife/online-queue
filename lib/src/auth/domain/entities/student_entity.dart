import 'package:online_queue/src/auth/data/models/student_model.dart';

class StudentEntity {
  final String? uid;
  final String nickname;
  final String email;
  final String? password;

  StudentEntity({this.uid, required this.nickname, required this.email, this.password});

  factory StudentEntity.fromModel(StudentModel model) {
    return StudentEntity(
      nickname: model.nickname,
      email: model.email,
      password: model.password,
    );
  }
}
