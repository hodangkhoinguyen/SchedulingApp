import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/models/availability.dart';
import 'package:scheduler_app/repository/data_repository.dart';
import 'package:intl/intl.dart';

// Screen for viewing available tutor availabilities, allows filtering by subject

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({Key? key}) : super(key: key);

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen> {
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

  void reloadDataBySubject(subject) {
    setState(() {
      _future = repository.getAvailabilitiesBySubject(subject, DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = subjects[0];
    _future = repository.getAvailabilitiesByTime(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    void registerAppointment(String documentID) {
      DataRepository()
          .assignAvailability(documentID, result.uid, result.displayName!);

      setState(() {
        _future = repository.getAvailabilitiesByTime(DateTime.now());
      });
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Select an availability",
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
                    registerAppointment: registerAppointment,
                  ),
                ));
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
  final ValueSetter<String> registerAppointment;

  const AvailabilityCard(
      {Key? key, required this.availability, required this.registerAppointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => showDialog(
            context: context,
            builder: (context) => ScheduleAppointmentPrompt(
                  availability: availability,
                )).then(
          (value) {
            if (value == 'Schedule') {
              registerAppointment(availability.documentId!);
              print(
                  "${availability.documentId!} assigned to student ${availability.studentName}");
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

// Prompt to confirm scheduling appointment with a tutor

class ScheduleAppointmentPrompt extends StatelessWidget {
  final Availability availability;

  const ScheduleAppointmentPrompt({Key? key, required this.availability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schedule appointment?'),
      content: Text(
          "An appointment with ${availability.tutorName} from ${availability.start.toLocal()} to ${availability.end.toLocal()} will be registered."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Schedule'),
          child: const Text('Schedule'),
        ),
      ],
    );
  }
}
