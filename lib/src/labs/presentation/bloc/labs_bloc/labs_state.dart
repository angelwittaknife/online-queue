import 'package:equatable/equatable.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';
import 'package:online_queue/src/labs/domain/entities/subject_entity.dart';

abstract class LabsState extends Equatable {
  const LabsState();
  @override
  List<Object?> get props => [];
}

class LabsInitial extends LabsState {}

class LabsLoading extends LabsState {}



class LabsLoaded extends LabsState {
  final List<LabEntity> labs;
  const LabsLoaded(this.labs);
  @override
  List<Object?> get props => [labs];
}

class LabsFailure extends LabsState {
  final String message;
  const LabsFailure(this.message);
  @override
  List<Object?> get props => [message];
}
