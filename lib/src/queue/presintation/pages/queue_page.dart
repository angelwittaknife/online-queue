import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';
import 'package:online_queue/src/queue/presintation/bloc/queue_bloc.dart';
import 'package:online_queue/src/queue/presintation/bloc/queue_event.dart';
import 'package:online_queue/src/queue/presintation/widgets/queue_widget.dart';
import 'package:online_queue/src/widgets/app_scaffold.dart';
// путь к твоему AppScaffold

class QueuePage extends StatelessWidget {
  final String labId;

  const QueuePage({Key? key, required this.labId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QueueBloc>(
      create: (_) {
        final repo = sl<QueueRepository>();
        return QueueBloc(repo)..add(LoadQueueByLab(labId));
      },
      child: AppScaffold(
        
        child: const QueueWidget(),
      ),
    );
  }
}
