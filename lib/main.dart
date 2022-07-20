import 'package:firebase_core/firebase_core.dart';
import 'package:scheduler_app/screens/select_screen.dart';
import 'package:scheduler_app/screens/sign_in_screen.dart';
import 'package:scheduler_app/screens/student_screen.dart';
import 'package:scheduler_app/screens/tutor_screen.dart';
import 'package:scheduler_app/screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Build Material App and set up page routes as well as theming

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler App',
      initialRoute: "/",
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/select': (context) => const SelectScreen(),
        '/tutor': (context) => const TutorScreen(),
        '/student': (context) => const StudentScreen(),
      },
      theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
          //primaryColor: Colors.white,
          primaryColorDark: Colors.black,
          canvasColor: Colors.white,
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
          // primaryColorLight: Colors.black,
          // primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
    );
  }
}
