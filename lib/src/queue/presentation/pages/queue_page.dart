// queue_page.dart (обновлённая версия)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/domain/usecases/get_current_uid_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/get_profile_usecase.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';
import 'package:online_queue/src/queue/presentation/bloc/queue_bloc.dart';
import 'package:online_queue/src/queue/presentation/bloc/queue_event.dart';
import 'package:online_queue/src/queue/presentation/bloc/queue_state.dart';
import 'package:online_queue/src/queue/presentation/widgets/queue_item.dart';
import 'package:online_queue/src/queue/presentation/widgets/slot_item.dart';
import 'package:online_queue/src/widgets/app_scaffold.dart';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';

class QueuePage extends StatelessWidget {
  final String labId;
  static const int maxSlots = 30;

  const QueuePage({super.key, required this.labId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QueueBloc(sl())..add(LoadQueueByLab(labId)),
      child: BlocConsumer<QueueBloc, QueueState>(
        listener: (context, state) {
          if (state is QueueLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message.isNotEmpty ? state.message : 'Ошибка')),
            );
          } else if (state is QueueLoadSuccess && state.recentlyAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Место успешно занято')),
            );
          }
        },
        builder: (context, state) {
          return AppScaffold(
            child: switch (state) {
              QueueLoadInProgress() => _buildLoading(context),
              QueueLoadFailure() => _buildError(state.message),
              QueueLoadSuccess() => _buildQueueList(context, state),
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SpinKitDualRing(
        color: Colors.orangeAccent,
        size: size.height * 0.12,
      ),
    );
  }

  Widget _buildError(String message) => Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildQueueList(BuildContext context, QueueLoadSuccess state) {
    final occupied = {for (final q in state.queue) q.numInQueue: q};

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: QueuePage.maxSlots,
          itemBuilder: (_, index) {
            final slotNumber = index + 1;
            final item = occupied[slotNumber];

            return item != null
                ? QueueItem(item: item)
                : SlotItem(
                    slotNumber: slotNumber,
                    onTap: () => _onAddSlot(context, slotNumber, state),
                  );
          },
        ),
        if (state.isAdding)
          _buildOverlay('Занятие места №${state.addingSlot}...'),
      ],
    );
  }

  Widget _buildOverlay(String text) => Positioned.fill(
        child: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );

  // Обновлённый метод: проверяет текущего пользователя, подтягивает nickname,
  // запрещает занять более одного слота в одной очереди и делает dispatch в Bloc.
 void _onAddSlot(BuildContext context, int slotNumber, QueueLoadSuccess state) async {
  final auth = sl<FirebaseAuth>();
  final user = auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Требуется войти в аккаунт')),
    );
    return;
  }

  final uid = user.uid;

  final alreadyInQueue = state.queue.any((q) => q.userId == uid);
  if (alreadyInQueue) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вы уже в очереди для этой лаборатории')),
    );
    return;
  }

  final getProfileUsecase = sl<GetProfileUsecase>();
  final Either<Failure, StudentEntity> profileRes =
      await getProfileUsecase.call(param: uid);

  if (!context.mounted) return;

  final nickname = profileRes.fold(
    (_) => uid,
    (student) => student.nickname,
  );

  final entity = QueueEntity(nickname, slotNumber, uid);
  context.read<QueueBloc>().add(AddQueueItem(item: entity, labId: labId));
}

}
