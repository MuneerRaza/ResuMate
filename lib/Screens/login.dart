import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:resumate/Screens/signup.dart';
import 'package:resumate/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Database/sqflite_database.dart';
import '../Model/user_model.dart';
import '../global_identifier.dart';
import 'applicant_dashboard.dart';
import 'company_dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Login",
              style: GoogleFonts.poppins(
                  fontSize: width * 0.05, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Form(
              key: _formfield,
              child: Column(
                children: [
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email!";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passController,
                      obscureText: !passToggle,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passToggle = !passToggle;
                            });
                          },
                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password!";
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formfield.currentState!.validate()) {
                        final enteredEmail = emailController.text;
                        final enteredPassword = passController.text;

                        // Check if the user with the entered email exists
                        final user =
                            await DatabaseUtil.instance.getUser(enteredEmail);

                        if (user != null && user.password == enteredPassword) {
                          var sharedpref =
                              await SharedPreferences.getInstance();
                          var email = emailController.text.trim();
                          sharedpref.setBool(MyApp.LOGINKEY, true);
                          sharedpref.setString(MyApp.EMAILKEY, email);
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

                          emailController.clear();
                          passController.clear();
                        } else if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'User not exist, Sign up First!',
                                style: GoogleFonts.poppins(),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Invalid email or password',
                                style: GoogleFonts.poppins(),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.only(
                          left: width * 0.37,
                          right: width * 0.37,
                          top: 20,
                          bottom: 20),
                    ),
                    child: Text(
                      "Log In",
                      style: GoogleFonts.poppins(fontSize: width * 0.04),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not Registered?",
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(_createRoute(const SignUp()));
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
