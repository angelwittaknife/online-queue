import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/labs/domain/usecases/get_subjects_usecase.dart';
import 'package:online_queue/src/labs/presentation/bloc/subjects_bloc/subject_event.dart';
import 'package:online_queue/src/labs/presentation/bloc/subjects_bloc/subject_state.dart';


class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(SubjectLoading()) {
    on<GetAllSubjectsEvent>(_getSubjects);
  }

  Future<void> _getSubjects(
    GetAllSubjectsEvent event,
    Emitter<SubjectState> emit,
  ) async {
    final result = await sl<GetSubjectsUsecase>()();

    result.fold(
      (error) => emit(SubjectFailure(error.message)),
      (data) => emit(SubjectsLoaded(data)),
    );
  }

 
}
