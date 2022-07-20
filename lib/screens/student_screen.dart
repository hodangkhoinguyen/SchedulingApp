import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/screens/student/student_appointments_screen.dart';
import 'package:scheduler_app/screens/student/student_schedule_screen.dart';
import 'package:scheduler_app/screens/student/student_past_screen.dart';

// tabbed screen for choosing between schedule, appointment, and past screens

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box),
            icon: Icon(Icons.add_box_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Appointments',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Past Meetings',
          ),
        ],
      ),
      body: SafeArea(
        child: <Widget>[
          const StudentScheduleScreen(),
          const StudentAppointmentsScreen(),
          const StudentPastAppointmentsScreen(),
        ][_currentPageIndex],
      ),
    );
  }
}
