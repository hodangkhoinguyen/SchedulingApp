import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler_app/models/availability.dart';

// Class for handling interactions with Firestore

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('availabilities');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<List<Availability>> getAvailabilitiesByTime(DateTime date,
      {bool past = false}) async {
    List<Availability> avails = [];

    Query<Object?> query = past
        ? collection.where("start", isLessThanOrEqualTo: date)
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query.where("studentID", isEqualTo: "").get().then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilities() async {
    List<Availability> avails = <Availability>[];

    await collection
        .where("studentID", isEqualTo: "")
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAppointmentsByStudentIdAndTime(
      String studentId, DateTime date,
      {bool past = false}) async {
    List<Availability> avails = <Availability>[];

    Query<Object?> query = past
        ? collection.where("start", isLessThanOrEqualTo: date)
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query
        .where("studentID", isEqualTo: studentId)
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAppointmentsByTutorIdAndTime(
      String tutorId, DateTime date,
      {bool past = false}) async {
    List<Availability> avails = <Availability>[];

    Query<Object?> query = past
        ? (collection.where("start", isLessThanOrEqualTo: date))
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query
        .where("tutorID", isEqualTo: tutorId)
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          if (Availability.fromJson(doc.data() as Map<String, dynamic>, doc.id)
                  .studentName !=
              "")
            avails.add(Availability.fromJson(
                doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAppointmentsByTutorId(String tutorID) async {
    List<Availability> avails = <Availability>[];

    await collection
        .where("tutorID", isEqualTo: tutorID)
        .where("studentID", isNotEqualTo: "")
        //.orderBy("start",descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAppointmentsByStudentId(
      String studentID) async {
    List<Availability> avails = <Availability>[];

    await collection
        .where("studentID", isEqualTo: studentID)
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilitiesByDay(DateTime date,
      {bool greaterThan = true}) async {
    List<Availability> avails = <Availability>[];

    Query<Object?> test = greaterThan
        ? collection.where("start", isGreaterThanOrEqualTo: date.toUtc())
        : collection.where("start", isLessThanOrEqualTo: date.toUtc());

    await collection
        .where("start", isGreaterThanOrEqualTo: date.toUtc())
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    // print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilitiesByTutorIdAndTime(
      String tutorId, DateTime date,
      {bool past = false}) async {
    List<Availability> avails = <Availability>[];

    Query<Object?> query = past
        ? collection.where("start", isLessThanOrEqualTo: date)
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query
        .where("tutorID", isEqualTo: tutorId)
        .where("studentID", isEqualTo: "")
        .orderBy("start", descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilitiesByTutorId(String tutorId) async {
    List<Availability> avails = <Availability>[];

    await collection
        .where("tutorID", isEqualTo: tutorId)
        .where("studentID", isEqualTo: "")
        //.orderBy("start",descending: false)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    // print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilitiesBySubject(
      String subject, DateTime date,
      {bool past = false}) async {
    List<Availability> avails = [];

    Query<Object?> query = past
        ? collection.where("start", isLessThanOrEqualTo: date)
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query
        .where("studentID", isEqualTo: "")
        .where("subject", isEqualTo: subject)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<List<Availability>> getAvailabilitiesByStudentIdAndSubject(
      String studentID, String subject, DateTime date,
      {bool past = false}) async {
    List<Availability> avails = [];

    Query<Object?> query = past
        ? collection.where("start", isLessThanOrEqualTo: date)
        : collection.where("start", isGreaterThanOrEqualTo: date);

    await query
        .where("studentID", isEqualTo: studentID)
        .where("subject", isEqualTo: subject)
        .get()
        .then(
      (res) {
        for (var doc in res.docs) {
          avails.add(Availability.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
          // print("now" + avails.length.toString());
        }
        // print("Success!" + avails.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print("finally is " + avails.length.toString());
    return avails;
  }

  Future<DocumentReference> addAvailability(Availability avail) {
    return collection.add(avail.toJson());
  }

  void assignAvailability(
      String documentID, String studentID, String studentName) async {
    await collection
        .doc(documentID)
        .update({'studentID': studentID, 'studentName': studentName});
  }

  void updateAvailability(Availability avail) async {
    await collection.doc(avail.documentId).update(avail.toJson());
  }

  void deleteAvailability(String documentID) async {
    await collection.doc(documentID).delete();
  }

  studentDeleteAvailability(String documentID) async {
    final now = DateTime.now();
    final later = now.add(const Duration(hours: 3));
    await collection.doc(documentID).get().then(
      (res) async {
        if (Availability.fromJson(res.data() as Map<String, dynamic>, res.id)
            .start
            .isAfter(later)) {
          await collection.doc(documentID).delete();
          print("laterr = $later}\n");
          print(
              "start = ${Availability.fromJson(res.data() as Map<String, dynamic>, res.id).start}\n");
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void updateTutorNotes(String documentID, String notes) async {
    await collection.doc(documentID).update({'tutorNotes': notes});
  }

  void updateStudentNotes(String documentID, String notes) async {
    await collection.doc(documentID).update({'studentNotes': notes});
  }
}
