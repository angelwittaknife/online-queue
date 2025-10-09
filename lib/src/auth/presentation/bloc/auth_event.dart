// auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final StudentEntity student;
  const RegisterRequested(this.student);
  @override
  List<Object?> get props => [student];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class LoadProfileRequested extends AuthEvent {
  final String uid;
  const LoadProfileRequested(this.uid);
  @override
  List<Object?> get props => [uid];
}

class UpdateNicknameRequested extends AuthEvent {
  final String uid;
  final String newNickname;
  const UpdateNicknameRequested({required this.uid, required this.newNickname});
  @override
  List<Object?> get props => [uid, newNickname];
}

class CheckCurrentUidRequested extends AuthEvent {
  const CheckCurrentUidRequested();
}
