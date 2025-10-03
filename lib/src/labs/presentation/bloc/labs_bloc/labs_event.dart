import 'package:equatable/equatable.dart';

abstract class LabsEvent extends Equatable {
  const LabsEvent();
  @override
  List<Object?> get props => [];
}

class GetAllLabsEvent extends LabsEvent {}


class GetLabsBySubjectEvent extends LabsEvent {
  final String subject;

  const GetLabsBySubjectEvent(this.subject);
  @override
  List<Object?> get props => [subject];
}

