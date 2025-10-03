
class SubjectModel {
  final String id;
  final String name;
  final String teacher;
  final String image;

  SubjectModel( this.id,this.name, this.teacher, this.image);
  factory SubjectModel.fromMap(String id, Map<String, dynamic> map) {
    return SubjectModel(
      id,
      map['name'] as String? ?? '',
      map['teacher'] as String? ?? '',
      map['image'] as String? ?? '',
    );
  }
}
