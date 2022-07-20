import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/repository/data_repository.dart';
import 'package:intl/intl.dart';

// Class for creating a new availability with given options for subject and start/end time

class CreateAvailabilityScreen extends StatefulWidget {
  const CreateAvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<CreateAvailabilityScreen> createState() =>
      _CreateAvailabilityScreenState();
}

class _CreateAvailabilityScreenState extends State<CreateAvailabilityScreen> {
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

  String dateTime = DateFormat.yMd().format(DateTime.now());

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedStartTime =
      TimeOfDay.now(); //const TimeOfDay(hour: 00, minute: 00);

  TimeOfDay selectedEndTime =
      TimeOfDay.now(); //const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeStartController = TextEditingController();
  final TextEditingController _timeEndController = TextEditingController();

  @override
  void initState() {
    dropdownValue = subjects[0];
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeStartController.text =
        DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now());
    _timeEndController.text =
        DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create Availability",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subject",
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
                },
                items: subjects.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Choose Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: TextField(
                  controller: _dateController,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 100));

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        _dateController.text =
                            DateFormat.yMd().format(pickedDate);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Choose Start Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: TextField(
                  controller: _timeStartController,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedStartTime = pickedTime;
                        _timeStartController.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Choose End Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: TextField(
                  controller: _timeEndController,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedEndTime = pickedTime;
                        _timeEndController.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ['Cancel']),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            DateTime start = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedStartTime.hour,
                selectedStartTime.minute);
            DateTime end = DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, selectedEndTime.hour, selectedEndTime.minute);
            Navigator.pop(context, ['Create', dropdownValue, start, end]);
          },
          style: TextButton.styleFrom(
            primary: Colors.blue,
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
