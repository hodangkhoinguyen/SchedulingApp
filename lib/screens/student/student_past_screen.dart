import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/models/availability.dart';
import 'package:scheduler_app/repository/data_repository.dart';
import 'package:intl/intl.dart';

class StudentPastAppointmentsScreen extends StatefulWidget {
  const StudentPastAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentPastAppointmentsScreen> createState() =>
      _StudentPastAppointmentsScreenState();
}

class _StudentPastAppointmentsScreenState
    extends State<StudentPastAppointmentsScreen> {
  User result = FirebaseAuth.instance.currentUser!;
  final DataRepository repository = DataRepository();
  late Future<List<Availability>> _future;

  void reloadData() {
    setState(() {
      _future = repository.getAppointmentsByStudentIdAndTime(
          result.uid, DateTime.now(),
          past: true);
    });
  }

  @override
  void initState() {
    super.initState();
    _future = repository.getAppointmentsByStudentIdAndTime(
        result.uid, DateTime.now(),
        past: true);
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
            child: Text("Past Meetings",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          SizedBox(height: size.height * 0.05),
          const Center(
              child: Text("Click on a card to review that meeting.",
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
          (value) {},
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

class AppointmentInfoPrompt extends StatelessWidget {
  final Availability availability;

  const AppointmentInfoPrompt({Key? key, required this.availability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Appointment Infomation'),
      content: SelectableText("Tutor's notes:  ${availability.tutorNotes}\n"
          "Your notes: ${availability.studentNotes}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Ok'),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
