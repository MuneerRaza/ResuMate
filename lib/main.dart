import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Screens/applicant_dashboard.dart';
import 'package:resumate/Screens/company_dashboard.dart';
import 'package:resumate/Screens/signup.dart';
import 'package:resumate/global_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Database/sqflite_database.dart';
import 'Model/user_model.dart';
import 'Screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String LOGINKEY = 'login';
  static const String EMAILKEY = 'email';

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resumate',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: const RouteIdentifier(),
    );
  }
}

class RouteIdentifier extends StatefulWidget {
  const RouteIdentifier({super.key});

  @override
  State<RouteIdentifier> createState() => _RouteIdentifierState();
}

class _RouteIdentifierState extends State<RouteIdentifier> {
  static const String LOGINKEY = 'login';
  static const String EMAILKEY = 'email';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        //     body: Container(
        //   color: Colors.black.withOpacity(0.5),
        //   child: const Center(
        //     child: CircularProgressIndicator(
        //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //     ),
        //   ),
        // )
        );
  }

  checkLoginStatus() async {
    var sharedpref = await SharedPreferences.getInstance();
    bool? isLoggedIn = sharedpref.getBool(LOGINKEY);
    String? email = sharedpref.getString(EMAILKEY);

    Future.delayed(Duration.zero, () async {
      if (isLoggedIn != null) {
        if (isLoggedIn && email != null) {
          User? user = await DatabaseUtil.instance.getUser(email);
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error while fetching data!',
                  style: GoogleFonts.poppins(),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (user.role == 'Applicant') {
            GlobalEmailKey.email = email;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ApplicantDashboard(
                  user: user,
                ),
              ),
            );
          } else if (user.role == 'Company') {
            GlobalEmailKey.email = email;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CompanyDashboard(user: user,),
              ),
            );
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      }
    });
  }
}

// this is hello