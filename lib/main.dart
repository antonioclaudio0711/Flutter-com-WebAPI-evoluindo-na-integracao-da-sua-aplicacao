import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/pages/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/pages/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/pages/home_screen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool verifyLogged = await verifyToken();
  runApp(
    MyApp(isLogged: verifyLogged),
  );
}

Future<bool> verifyToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString("accessToken");

  if (token != null) {
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  const MyApp({Key? key, required this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: isLogged ? "home" : "login-screen",
      routes: {
        "home": (context) => const HomeScreen(),
        "login-screen": (context) => LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map['journal'] as Journal;
          final bool isEditing = map['isEditing'];
          return MaterialPageRoute(
            builder: (context) => AddJournalScreen(
              journal: journal,
              isEditing: isEditing,
            ),
          );
        }

        return null;
      },
    );
  }
}
