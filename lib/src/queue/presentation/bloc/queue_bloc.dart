import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/auth/domain/usecases/get_profile_usecase.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';
import 'package:online_queue/src/queue/domain/usecases/add_queue_params.dart';
import 'package:online_queue/src/queue/domain/usecases/add_queue_usecase.dart';
import 'package:online_queue/src/queue/domain/usecases/get_queue_bylab.dart';
import 'package:online_queue/src/queue/presentation/bloc/queue_event.dart';
import 'package:online_queue/src/queue/presentation/bloc/queue_state.dart';

class QueueBloc extends Bloc<QueueEvent, QueueState> {
  final QueueRepository repo;

  QueueBloc(this.repo) : super(QueueInitial()) {
    on<LoadQueueByLab>(_onLoadQueue);
    on<AddQueueItem>(_onAddItem);
    on<TryAddSlot>(_onTryAddSlot);

  }

  Future<void> _onLoadQueue(
    LoadQueueByLab event,
    Emitter<QueueState> emit,
  ) async {
    emit(QueueLoadInProgress());

    await emit.forEach<Either<Failure, List<QueueEntity>>>(
      sl<GetQueueByLabUsecase>()(param: event.labId), // поток
      onData: (either) => either.fold(
        (failure) => QueueLoadFailure(failure.message),
        (list) => QueueLoadSuccess(list),
      ),
      onError: (_, __) => const QueueLoadFailure('Ошибка загрузки потока'),
    );
  }

  Future<void> _onAddItem(AddQueueItem event, Emitter<QueueState> emit) async {
    final currentState = state;
    if (currentState is QueueLoadSuccess) {
      emit(currentState.copyWith(isAdding: true, addingSlot: event.item.numInQueue));
    }

    final addUsecase = sl<AddQueueUsecase>();
    final params = AddQueueParams(first: event.item, second: event.labId);

    final Either<Failure, bool> result = await addUsecase(param: params);

    result.fold(
      (failure) => emit(QueueLoadFailure(failure.message)),
      (success) {
        if (success) {
          if (currentState is QueueLoadSuccess) {
            emit(currentState.copyWith(
              isAdding: false,
              recentlyAdded: true,
              addingSlot: null,
            ));
          }
        } else {
          emit(const QueueLoadFailure('Не удалось занять место'));
        }
      },
    );
  }

Future<void> _onTryAddSlot(TryAddSlot event, Emitter<QueueState> emit) async {
  final auth = sl<FirebaseAuth>();
  final user = auth.currentUser;
  if (user == null) {
    emit(const QueueLoadFailure('Требуется войти в аккаунт'));
    return;
  }

  final uid = user.uid;
  final getProfileUsecase = sl<GetProfileUsecase>();
  final profileRes = await getProfileUsecase.call(param: uid);

  final nickname = profileRes.fold(
    (_) => user.displayName ?? uid,
    (student) => student.nickname.isNotEmpty ? student.nickname : uid,
  );

  final currentState = state;
  if (currentState is QueueLoadSuccess) {
    final alreadyInQueue = currentState.queue.any((q) => q.userId == uid);
    if (alreadyInQueue) {
      emit(const QueueLoadFailure('Вы уже в очереди'));
      return;
    }

    final entity = QueueEntity(nickname, event.slotNumber, uid);
    add(AddQueueItem(item: entity, labId: event.labId));
  }
}

}
