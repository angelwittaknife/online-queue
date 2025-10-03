import 'package:online_queue/src/labs/data/models/subject_model.dart';

class SubjectEntity {
  final String name;
  final String teacher;
  final String image;

  SubjectEntity(this.name, this.teacher, this.image);

  factory SubjectEntity.fromModel(SubjectModel m) =>
      SubjectEntity(m.name, m.teacher, m.image);
}
