import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scheduler_app/screens/tutor/tutor_appointments_screen.dart';
import 'package:scheduler_app/screens/tutor/tutor_availability_screen.dart';
import 'package:scheduler_app/screens/tutor/tutor_past_screen.dart';

// tutor screen for selecting between availability, appointments, and past screens

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
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
            label: 'Availability',
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
          const TutorAvailabilityScreen(),
          Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const TutorAppointmentsScreen()),
          Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: const TutorPastAppointmentsScreen(),
          ),
        ][_currentPageIndex],
      ),
    );
  }
}
