import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/labs/domain/usecases/get_labs_by_subj_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/get_subjects_usecase.dart';
import 'package:online_queue/src/labs/presentation/bloc/labs_bloc/labs_state.dart';

import 'labs_event.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  LabsBloc() : super(LabsLoading()) {
    on<GetLabsBySubjectEvent>(_getLabsBySubject);
  }



  Future<void> _getLabsBySubject(
    GetLabsBySubjectEvent event,
    Emitter<LabsState> emit,
  ) async {
    final result = await sl<GetLabsBySubjectUsecase>()(param: event.subject);

    result.fold(
      (error) => emit(LabsFailure(error.message)),
      (data) => emit(LabsLoaded(data)),
    );
  }
}
