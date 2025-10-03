import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_queue/src/labs/presentation/bloc/subjects_bloc/subject_bloc.dart';
import 'package:online_queue/src/labs/presentation/bloc/subjects_bloc/subject_event.dart';
import 'package:online_queue/src/labs/presentation/bloc/subjects_bloc/subject_state.dart';
import 'package:online_queue/src/labs/presentation/widgets/subject_card.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubjectBloc>(
      create: (context) => SubjectBloc()..add(GetAllSubjectsEvent()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<SubjectBloc, SubjectState>(
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
                            'Предметы',
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
                            if (state is SubjectLoading) {
                              return Center(
                                child: SpinKitDualRing(
                                  color: Colors.orangeAccent,
                                  size: size.height * 0.12,
                                ),
                              );
                            }

                            if (state is SubjectsLoaded) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: state.subjects.map((e) {
                                    return SizedBox(
                                      height: 120,
                                      child: SubjectCard(subject: e),
                                    );
                                  }).toList(),
                                ),
                              );
                            }

                            if (state is SubjectFailure) {
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
