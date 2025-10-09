import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';

class StudentModel {
  final String nickname;
  final String email;
  final String? password;

  StudentModel(this.nickname, this.email, this.password);

  Map<String, dynamic> toFirestoreMap() {
    return {
      'nickname': nickname,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(), 
    };
  }

  Map<String, String> toAuthCredentials() {
    return {
      'email': email,
      'password': password!,
    };
  }
   factory StudentModel.fromFirestoreMap(Map<String, dynamic> map) {
    return StudentModel(
      map['nickname'] as String? ?? '',
      map['email'] as String? ?? '',
      null, // пароль отсутствует в Firestore
    );
  }
  factory StudentModel.fromEntity(StudentEntity entity)
  {
    return StudentModel(entity.nickname, entity.email, entity.password);
  }
}
