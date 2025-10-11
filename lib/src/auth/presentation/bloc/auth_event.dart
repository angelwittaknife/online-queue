part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// --- Управление формой ---
class EmailChanged extends AuthEvent {
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class NicknameChanged extends AuthEvent {
  final String nickname;
  const NicknameChanged(this.nickname);
  @override
  List<Object?> get props => [nickname];
}

class ToggleAuthMode extends AuthEvent {
  const ToggleAuthMode();
}

class SubmitAuthForm extends AuthEvent {
  const SubmitAuthForm();
}

// --- Остальные действия ---
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
