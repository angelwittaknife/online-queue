import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  final String id;
  final String title;
  final DateTime deadline;
  final bool isOpen;
  final String subject;
  final String description;
  const LabModel(
    this.id,
    this.title,
    this.deadline,
    this.isOpen,
    this.subject,
    this.description,
  );

  Map<String, dynamic> toMap() {
    return {
      'createdAt': FieldValue.serverTimestamp(),
      'deadline': Timestamp.fromDate(deadline),
      "description": description,
      "isOpen": isOpen,
      "subject": subject,
      "title": title,
    };
  }

  factory LabModel.fromMap(String id, Map<String, dynamic> map) {
    final deadlineValue = map['deadline'];
    DateTime parsedDeadline;
    if (deadlineValue is Timestamp) {
      parsedDeadline = deadlineValue.toDate();
    } else if (deadlineValue is String) {
      parsedDeadline = DateTime.parse(deadlineValue);
    } else if (deadlineValue is DateTime) {
      parsedDeadline = deadlineValue;
    } else {
      parsedDeadline = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return LabModel(
      id,
      map['title'] as String? ?? '',
      parsedDeadline,
      map['isOpen'] as bool? ?? false,
      map['subject'] as String? ?? '',
      map['description'] as String? ?? '',
    );
  }

  factory LabModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    return LabModel.fromMap(snap.id, snap.data() ?? <String, dynamic>{});
  }
}
