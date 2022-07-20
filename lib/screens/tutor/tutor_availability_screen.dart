import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_app/models/availability.dart';
import 'package:scheduler_app/repository/data_repository.dart';
import 'package:scheduler_app/screens/tutor/create_availability_screen.dart';
import 'package:intl/intl.dart';

// Screen for viewing or deleting existing availabilities or creating new ones

class TutorAvailabilityScreen extends StatefulWidget {
  const TutorAvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<TutorAvailabilityScreen> createState() =>
      _TutorAvailabilityScreenState();
}

class _TutorAvailabilityScreenState extends State<TutorAvailabilityScreen> {
  User result = FirebaseAuth.instance.currentUser!;
  final DataRepository repository = DataRepository();
  late Future<List<Availability>> _future;

  @override
  void initState() {
    super.initState();
    _future = repository.getAvailabilitiesByTutorIdAndTime(
        result.uid, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DataRepository repository = DataRepository();

    void reloadData() {
      setState(() {
        _future = repository.getAvailabilitiesByTutorIdAndTime(
            result.uid, DateTime.now());
      });
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Current Availabilities",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          SizedBox(height: size.height * 0.05),
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
                child: CircularProgressIndicator(),
              ); // Else return loading indicator
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Create"),
        icon: const Icon(Icons.create),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => const CreateAvailabilityScreen()).then(
          (value) {
            if (value != null && value[0] == 'Create') {
              print(DateTime.now());
              DataRepository().addAvailability(Availability(
                  result.uid,
                  result.displayName!,
                  "",
                  "",
                  value[1],
                  value[2],
                  value[3],
                  "",
                  ""));
              reloadData();
            }
          },
        ),
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
        splashColor: Colors.deepPurple.withAlpha(30),
        onTap: () => showDialog(
            context: context,
            builder: (context) => DeleteAvailabilityPrompt(
                  availability: availability,
                )).then(
          (value) {
            if (value == 'Delete') {
              DataRepository().deleteAvailability(availability.documentId!);
              reloadParentData();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Popup dialog to allow user to delete existing availability

class DeleteAvailabilityPrompt extends StatelessWidget {
  final Availability availability;

  const DeleteAvailabilityPrompt({Key? key, required this.availability})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete availability?'),
      content: Text(
        "The availability from \n ${availability.start.toLocal()} to \n ${availability.end.toLocal()} \n will be deleted.",
        //textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Delete'),
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
