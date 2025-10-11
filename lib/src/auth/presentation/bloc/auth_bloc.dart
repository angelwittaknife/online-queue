import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/auth/domain/usecases/register_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/sign_in_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/sign_out_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/get_profile_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/update_nickname_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/get_current_uid_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase _register = sl<RegisterUsecase>();
  final SignInUsecase _signIn = sl<SignInUsecase>();
  final SignOutUsecase _signOut = sl<SignOutUsecase>();
  final GetProfileUsecase _getProfile = sl<GetProfileUsecase>();
  final UpdateNicknameUsecase _updateNickname = sl<UpdateNicknameUsecase>();
  final GetCurrentUidUsecase _getCurrentUid = sl<GetCurrentUidUsecase>();

  AuthBloc() : super(const AuthFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NicknameChanged>(_onNicknameChanged);
    on<ToggleAuthMode>(_onToggleAuthMode);
    on<SubmitAuthForm>(_onSubmitForm);
    on<SignOutRequested>(_onSignOutRequested);
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateNicknameRequested>(_onUpdateNicknameRequested);
    on<CheckCurrentUidRequested>(_onCheckCurrentUidRequested);
  }

  // --- UI events ---
  void _onEmailChanged(EmailChanged e, Emitter<AuthState> emit) {
    if (state is AuthFormState) {
      emit((state as AuthFormState).copyWith(email: e.email, error: null));
    }
  }

  void _onPasswordChanged(PasswordChanged e, Emitter<AuthState> emit) {
    if (state is AuthFormState) {
      emit((state as AuthFormState).copyWith(password: e.password, error: null));
    }
  }

  void _onNicknameChanged(NicknameChanged e, Emitter<AuthState> emit) {
    if (state is AuthFormState) {
      emit((state as AuthFormState).copyWith(nickname: e.nickname, error: null));
    }
  }

  void _onToggleAuthMode(ToggleAuthMode e, Emitter<AuthState> emit) {
    if (state is AuthFormState) {
      final current = state as AuthFormState;
      final newMode = current.mode == AuthMode.signIn
          ? AuthMode.register
          : AuthMode.signIn;
      emit(current.copyWith(mode: newMode, error: null));
    }
  }

  Future<void> _onSubmitForm(SubmitAuthForm e, Emitter<AuthState> emit) async {
    if (state is! AuthFormState) return;
    final current = state as AuthFormState;

    // 🔹 Валидация
    if (current.email.isEmpty || current.password.isEmpty) {
      emit(current.copyWith(error: 'Введите email и пароль'));
      return;
    }
    if (current.mode == AuthMode.register && current.nickname.isEmpty) {
      emit(current.copyWith(error: 'Введите имя пользователя'));
      return;
    }

    emit(current.copyWith(isLoading: true, error: null));

    // 🔹 Выполнение входа / регистрации
    if (current.mode == AuthMode.signIn) {
      final result = await _signIn(
        param: SignInParams(
          email: current.email,
          password: current.password,
        ),
      );

      result.fold(
        (failure) =>
            emit(current.copyWith(isLoading: false, error: failure.message)),
        (uid) => emit(Authenticated(uid)),
      );
    } else {
      final result = await _register(
        param: StudentEntity(
          uid: '',
          nickname: current.nickname,
          email: current.email,
          password: current.password,
        ),
      );

      result.fold(
        (failure) =>
            emit(current.copyWith(isLoading: false, error: failure.message)),
        (uid) => emit(Authenticated(uid)),
      );
    }
  }

  // --- Logic events ---
  Future<void> _onSignOutRequested(
      SignOutRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signOut();
    result.fold(
      (f) => emit(AuthFailure(f.message)),
      (_) => emit(const AuthFormState()), // возвращаем форму после выхода
    );
  }

  Future<void> _onLoadProfileRequested(
      LoadProfileRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _getProfile(param: e.uid);
    result.fold(
      (f) => emit(AuthFailure(f.message)),
      (student) => emit(ProfileLoadSuccess(student)),
    );
  }

  Future<void> _onUpdateNicknameRequested(
      UpdateNicknameRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _updateNickname(
      param: UpdateNicknameParams(uid: e.uid, newNickname: e.newNickname),
    );
    result.fold(
      (f) => emit(AuthFailure(f.message)),
      (_) => emit(NicknameUpdateSuccess(e.newNickname)),
    );
  }

  Future<void> _onCheckCurrentUidRequested(
      CheckCurrentUidRequested e, Emitter<AuthState> emit) async {
    final result = await _getCurrentUid();
    result.fold(
      (f) => emit(const AuthFormState()), // нет авторизации
      (uid) => emit(Authenticated(uid)), // уже авторизован
    );
  }
}
