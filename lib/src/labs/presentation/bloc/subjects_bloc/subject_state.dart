import 'package:equatable/equatable.dart';
import 'package:online_queue/src/labs/domain/entities/subject_entity.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();
  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectsLoaded extends SubjectState{
  final List<SubjectEntity> subjects;

  const SubjectsLoaded(this.subjects);
  @override
  List<Object?> get props => [subjects];
}



class SubjectFailure extends SubjectState {
  final String message;
  const SubjectFailure(this.message);
  @override
  List<Object?> get props => [message];
}
