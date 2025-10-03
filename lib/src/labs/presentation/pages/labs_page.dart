import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_bloc.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_event.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_state.dart';
import 'package:online_queue/src/labs/presentation/widgets/lab_item.dart';

class LabsPage extends StatelessWidget {
  final String subject;
  const LabsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabsBloc>(
      create: (context) => LabsBloc()..add(GetLabsBySubjectEvent(subject)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<LabsBloc, LabsState>(
            builder: (context, state) {
              final size = MediaQuery.sizeOf(context);

              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0F2027),
                          Color(0xFF203A43),
                          Color(0xFF2C5364),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: -60,
                    left: -60,
                    child: _DecorCircle(size: 180, color: Colors.white24),
                  ),
                  const Positioned(
                    top: 40,
                    right: -40,
                    child: _DecorCircle(size: 120, color: Colors.white10),
                  ),
                  const Positioned(
                    bottom: -80,
                    right: -40,
                    child: _DecorCircle(size: 220, color: Colors.white12),
                  ),

                  Column(
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                itemCount: labs.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final lab = labs[index];
                                  return LabItem(
                                    lab: lab,
                                    dense: false,
                                    onTap: () {
                                      // Пример навигации — заменяй под свой роутер
                                      // context.goNamed('labDetails', extra: lab);
                                      // или
                                      // Navigator.of(context).push(...);
                                    },
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

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
    );
  }
}
