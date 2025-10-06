import 'package:online_queue/src/labs/data/models/lab_model.dart';

class LabEntity {
  final String id;
  final String title;
  final DateTime deadline;
  final bool isOpen;
  final String subject;
  final String description;
  const LabEntity(
    this.id,
    this.title,
    this.deadline,
    this.isOpen,
    this.subject,
    this.description,
  );
  factory LabEntity.fromModel(LabModel lab) {
    return LabEntity(
      lab.id,
      lab.title,
      lab.deadline,
      lab.isOpen,
      lab.subject,
      lab.description,
    );
  }
} 
