import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_bloc.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_event.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_state.dart';
import 'package:online_queue/src/labs/presentation/widgets/lab_item.dart';
import 'package:online_queue/src/widgets/app_scaffold.dart';

class LabsPage extends StatelessWidget {
  final String subject;
  const LabsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabsBloc>(
      create: (context) => LabsBloc()..add(GetLabsBySubjectEvent(subject)),
      child: AppScaffold(
        child: SafeArea(
          child: BlocBuilder<LabsBloc, LabsState>(
            builder: (context, state) {
              final size = MediaQuery.sizeOf(context);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subject,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is LabsLoading) {
                          return Center(
                            child: SpinKitDualRing(
                              color: Colors.orangeAccent,
                              size: size.height * 0.12,
                            ),
                          );
                        }

                        if (state is LabsLoaded) {
                          final labs = state.labs;
                          if (labs.isEmpty) {
                            return Center(
                              child: Text(
                                'Нет лабораторных',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: labs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final lab = labs[index];
                              return LabItem(
                                lab: lab,
                                dense: false,
                    
                              );
                            },
                          );
                        }

                        if (state is LabsFailure) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

