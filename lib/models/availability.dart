import 'package:cloud_firestore/cloud_firestore.dart';

// Availability model for storing info and converting between firestore

class Availability {
  String tutorID;
  String tutorName;
  String studentID;
  String studentName;
  String subject;
  DateTime start;
  DateTime end;
  String tutorNotes;
  String studentNotes;
  String? documentId;

  Availability(this.tutorID, this.tutorName, this.studentID, this.studentName,
      this.subject, this.start, this.end, this.tutorNotes, this.studentNotes,
      [this.documentId]);

  factory Availability.fromSnapshot(DocumentSnapshot snapshot) {
    final newAvailability = Availability.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
    newAvailability.documentId = snapshot.reference.id;
    return newAvailability;
  }

  factory Availability.fromJson(Map<String, dynamic> json, String id) =>
      _availabilityFromJson(json, id);

  Map<String, dynamic> toJson() => _availabilityToJson(this);
}

Availability _availabilityFromJson(Map<String, dynamic> json, String id) {
  return Availability(
      json['tutorID'] as String,
      json['tutorName'] as String,
      json['studentID'] as String,
      json['studentName'] as String,
      json['subject'] as String,
      (json['start'] as Timestamp).toDate(),
      (json['end'] as Timestamp).toDate(),
      json['tutorNotes'] as String,
      json['studentNotes'] as String,
      id);
}

Map<String, dynamic> _availabilityToJson(Availability instance) =>
    <String, dynamic>{
      'tutorID': instance.tutorID,
      'tutorName': instance.tutorName,
      'studentID': instance.studentID,
      'studentName': instance.studentName,
      'subject': instance.subject,
      'start': instance.start.toUtc(),
      'end': instance.end.toUtc(),
      'tutorNotes': instance.tutorNotes,
      'studentNotes': instance.studentNotes,
    };
