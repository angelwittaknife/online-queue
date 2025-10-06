import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';
import 'package:online_queue/src/queue/presintation/bloc/queue_event.dart';
import 'package:online_queue/src/queue/presintation/bloc/queue_state.dart';

class QueueBloc extends Bloc<QueueEvent, QueueState> {
  final  repository = sl<QueueRepository>();

  QueueBloc(QueueRepository repo) : super(QueueInitial()) {
    on<LoadQueueByLab>(_onLoadQueue);
    on<AddQueueItem>(_onAddItem);
  }

  Future<void> _onLoadQueue(
    LoadQueueByLab event,
    Emitter<QueueState> emit,
  ) async {
    emit(QueueLoadInProgress());
    await emit.forEach<Either<Failure, List<QueueEntity>>>(
      repository.getQueueByLab(event.labId),
      onData: (either) => either.fold(
        (failure) => QueueLoadFailure(failure.message),
        (list) => QueueLoadSuccess(list),
      ),
    );
  }

  Future<void> _onAddItem(
    AddQueueItem event,
    Emitter<QueueState> emit,
  ) async {
    await repository.addQueue(event.item, event.labId);
    // поток LoadQueueByLab уже слушает обновления, поэтому тут 
    // можно не менять состояние вручную
  }
}
