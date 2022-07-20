import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/models/availability.dart';
import 'package:scheduler_app/repository/data_repository.dart';
import 'package:intl/intl.dart';

// Screen for displaying a student's existing availabilities and adding notes or deleting

class StudentAppointmentsScreen extends StatefulWidget {
  const StudentAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentAppointmentsScreen> createState() =>
      _StudentAppointmentsScreenState();
}

class _StudentAppointmentsScreenState extends State<StudentAppointmentsScreen> {
  User result = FirebaseAuth.instance.currentUser!;
  final DataRepository repository = DataRepository();
  late Future<List<Availability>> _future;

  final List<String> subjects = [
    "General",
    "Math",
    "Computer Science",
    "Biology",
    "Chemistry",
    "Psychology",
    "Linguistics",
  ];
  String dropdownValue = "";

  void reloadData() {
    setState(() {
      _future = repository.getAppointmentsByStudentIdAndTime(
          result.uid, DateTime.now());
    });
  }

  void reloadDataBySubject(subject) {
    setState(() {
      _future = repository.getAvailabilitiesByStudentIdAndSubject(
          result.uid, subject, DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();
    _future = repository.getAppointmentsByStudentIdAndTime(
        result.uid, DateTime.now());
    dropdownValue = subjects[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Scheduled Appointments",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          SizedBox(height: size.height * 0.05),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter by Subject",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      reloadDataBySubject(dropdownValue);
                    },
                    items:
                        subjects.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              )),
          const Center(
              child: Text(
                  "Click on a card to edit that appointment.\n"
                  "You can't delete appointments within 3 hours. \nIf you can't attend, Please contact the tutor directly.\n",
                  style: TextStyle(
                    color: Colors.grey,
                  ))),
          FutureBuilder(
            // Future Builder builds UI when Future returns data
            future: _future,
            builder: (context, AsyncSnapshot<List<Availability>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => AvailabilityCard(
                        availability: snapshot.data![index],
                        reloadParentData: reloadData),
                  ),
                );
              }
              return const Center(
                  child:
                      CircularProgressIndicator()); // Else return loading indicator
            },
          ),
        ],
      ),
    );
  }
}

// Card used by listview to display availability information

class AvailabilityCard extends StatelessWidget {
  final Availability availability;
  final VoidCallback reloadParentData;

  const AvailabilityCard(
      {Key? key, required this.availability, required this.reloadParentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => showDialog(
            context: context,
            builder: (context) => AppointmentInfoPrompt(
                  availability: availability,
                )).then(
          (value) {
            if (value == 'Delete') {
              DataRepository()
                  .studentDeleteAvailability(availability.documentId!);
              reloadParentData();
            } else if (value == 'Add Notes') {
              showDialog(
                  context: context,
                  builder: (context) => AddNotesPrompt(
                        availability: availability,
                      )).then((value) {
                if (value == 'Post Notes') {
                  DataRepository().updateStudentNotes(
                      availability.documentId!, controller.text);
                  reloadParentData();
                }
              });
            }
          },
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tutor: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(availability.tutorName)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Subject: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(availability.subject)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Start Time: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat('EEE, M/d/y h:mm a')
                      .format(availability.start))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("End Time: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat('EEE, M/d/y h:mm a').format(availability.end))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog prompt to view notes of an availability

class AppointmentInfoPrompt extends StatelessWidget {
  final Availability availability;

  const AppointmentInfoPrompt({Key? key, required this.availability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Appointment Infomation'),
      content: SelectableText("Tutor's notes:  ${availability.tutorNotes}\n\n"
          "Your notes: ${availability.studentNotes}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Add Notes'),
          child: const Text('Add/Adjust Notes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Delete Appointment'),
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// Prompt to add student's notes to an availability

TextEditingController controller = TextEditingController();

class AddNotesPrompt extends StatelessWidget {
  final Availability availability;

  const AddNotesPrompt({Key? key, required this.availability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Notes...'),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(hintText: "Add Your notes here :)"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Post Notes'),
          child: const Text('Post Notes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
