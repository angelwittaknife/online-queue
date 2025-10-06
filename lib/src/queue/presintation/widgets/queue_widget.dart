import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:online_queue/src/queue/presintation/bloc/queue_bloc.dart';
import 'package:online_queue/src/queue/presintation/bloc/queue_state.dart';

class QueueWidget extends StatelessWidget {
  const QueueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<QueueBloc, QueueState>(
      builder: (context, state) {
        if (state is QueueLoadInProgress) {
          return Center(
            child: SpinKitDualRing(
              color: Colors.orangeAccent,
              size: size.height * 0.12,
            ),
          );
        }

        if (state is QueueLoadSuccess) {
          final queue = state.queue;
          if (queue.isEmpty) {
            return Center(
              child: Text(
                'Очередь пуста',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: queue.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = queue[index];
              return ListTile(
                tileColor: Colors.white10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Text(
                    item.numInQueue.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  item.nickname,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'ID: ${item.userId}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onTap: () {
                  // обрабатывай нажатие по элементу, если нужно
                },
              );
            },
          );
        }

        if (state is QueueLoadFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
