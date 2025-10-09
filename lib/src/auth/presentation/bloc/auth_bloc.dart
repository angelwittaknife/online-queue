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

  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>(_handleRegister);
    on<SignInRequested>(_handleSignIn);
    on<SignOutRequested>(_handleSignOut);
    on<LoadProfileRequested>(_handleLoadProfile);
    on<UpdateNicknameRequested>(_handleUpdateNickname);
    on<CheckCurrentUidRequested>(_handleCheckCurrentUid);
  }

  /// 🔁 Универсальный шаблон для обработки usecase-результатов
  Future<void> _runUsecase<T>(
    Emitter<AuthState> emit,
    Future<Either<Failure, T>> Function() call,
    void Function(T value) onSuccess,
  ) async {
    emit(AuthLoading());
    final result = await call();
    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      onSuccess,
    );
  }

  Future<void> _handleRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<String>(
      emit,
      () => _register(param: event.student),
      (uid) => emit(Authenticated(uid)),
    );
  }

  Future<void> _handleSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<String>(
      emit,
      () => _signIn(param: SignInParams(email: event.email, password: event.password)),
      (uid) => emit(Authenticated(uid)),
    );
  }

  Future<void> _handleSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<void>(
      emit,
      () => _signOut(),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _handleLoadProfile(LoadProfileRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<StudentEntity>(
      emit,
      () => _getProfile(param: event.uid),
      (student) => emit(ProfileLoadSuccess(student)),
    );
  }

  Future<void> _handleUpdateNickname(UpdateNicknameRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<void>(
      emit,
      () => _updateNickname(param: UpdateNicknameParams(uid: event.uid, newNickname: event.newNickname)),
      (_) => emit(NicknameUpdateSuccess(event.newNickname)),
    );
  }

  Future<void> _handleCheckCurrentUid(CheckCurrentUidRequested event, Emitter<AuthState> emit) async {
    await _runUsecase<String>(
      emit,
      () => _getCurrentUid(),
      (uid) => emit(Authenticated(uid)),
    );
  }

  String _mapFailureToMessage(Failure failure) => failure.message;
}
