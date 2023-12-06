import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:resumate/Screens/Login.dart';
import 'package:resumate/Screens/applicant_dashboard.dart';
import 'package:resumate/Screens/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Database/sqflite_database.dart';
import '../Model/user_model.dart';
import '../global_identifier.dart';
import '../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formfield = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .sizeOf(context)
        .width;
    double height = MediaQuery
        .sizeOf(context)
        .height;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent)
    );
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text("Sign Up", style: GoogleFonts.poppins(
            fontSize: width * 0.05, fontWeight: FontWeight.bold),),
      ),
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: height * 0.04),
            child: Form(
              key: _formfield,
              child: Column(
                children: [
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(height: 20,),
                  Text("Let's Create Account!", style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w500),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 80, 30, 30),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.text_fields),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Name!";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
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
                        bool isValidEmail = RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                            .hasMatch(value);
                        if (!isValidEmail) {
                          return "Enter Valid Email!";
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
                          child: Icon(passToggle ? Icons.visibility : Icons
                              .visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password!";
                        }
                        if (passController.text.length < 6) {
                          return "Password should be more than 6 characters!";
                        }
                      },
                    ),
                  ),
                  ElevatedButton(onPressed: () async {
                    if (_formfield.currentState!.validate()) {
                      Future<bool> flag = dbWork();
                      if (await flag) {
                        final user = User(
                          email: emailController.text,
                          name: nameController.text,
                          password: passController.text,
                        );
                        var sharedpref = await SharedPreferences.getInstance();
                        var email = emailController.text.trim();
                        sharedpref.setBool(MyApp.LOGINKEY, true);
                        sharedpref.setString(MyApp.EMAILKEY, email);
                        GlobalEmailKey.email = email;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategorySelectionPopup(user: user, signUpContext: context);
                          },
                        );

                        nameController.clear();
                        emailController.clear();
                        passController.clear();
                      } else {
                        var snackBar = SnackBar(content: Text(
                          "User with this email already exists.",
                          style: GoogleFonts.poppins(),));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                    style: ElevatedButton.styleFrom(
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),),
                      padding: EdgeInsets.only(left: width * 0.37,
                          right: width * 0.37,
                          top: 20,
                          bottom: 20),
                    ),
                    child: Text("Sign Up",
                      style: GoogleFonts.poppins(fontSize: width * 0.04),),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                        style: GoogleFonts.poppins(),),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(_createRoute(
                              const Login()));
                        },
                        child: Text("Login", style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline),),),
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

  Future<bool> dbWork() async {
    final existingUser = await DatabaseUtil.instance.getUser(
        emailController.text);
    if (existingUser!=null) {
      return false;
    } else {
      return true;
    }
  }
}
Route _createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
