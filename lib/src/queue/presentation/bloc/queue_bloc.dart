import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/core/errors/failures.dart';
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
}
