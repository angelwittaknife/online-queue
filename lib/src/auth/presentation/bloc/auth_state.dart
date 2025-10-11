// auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String uid;
  const Authenticated(this.uid);
  @override
  List<Object?> get props => [uid];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileLoadSuccess extends AuthState {
  final StudentEntity student;
  const ProfileLoadSuccess(this.student);
  @override
  List<Object?> get props => [student];
}

class NicknameUpdateSuccess extends AuthState {
  final String nickname;
  const NicknameUpdateSuccess(this.nickname);
  @override
  List<Object?> get props => [nickname];
}
enum AuthMode { signIn, register }

class AuthFormState extends AuthState {
  final String email;
  final String password;
  final String nickname;
  final AuthMode mode;
  final bool isLoading;
  final String? error;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.nickname = '',
    this.mode = AuthMode.signIn,
    this.isLoading = false,
    this.error,
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    String? nickname,
    AuthMode? mode,
    bool? isLoading,
    String? error,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [email, password, nickname, mode, isLoading, error];
}
