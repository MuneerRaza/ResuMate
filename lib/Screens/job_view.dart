import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resumate/Database/sqflite_database.dart';

import '../Model/applicant_model.dart';
import '../Model/application_model.dart';
import '../Model/job_model.dart';

class JobView extends StatefulWidget {
  final Job job;
  final Applicant applicant;
  const JobView({required this.applicant, required this.job, super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {

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
    var job = widget.job;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text("Job Details", style: GoogleFonts.poppins(
              fontSize: width * 0.05, fontWeight: FontWeight.bold),
        ),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            elevation: 0),
        body: Column(
          children: [
            Container(
              width: width-20,
              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job Title:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.title,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Description:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.description,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Location:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.location,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Requirements:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.requirements,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pay:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.pay.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Type:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    job.type,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Last Date:",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM, yyyy').format(job.lastDate),
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 60,),
                  Center(
                    child: ElevatedButton(onPressed: (){
                      dbWork();
                      Navigator.of(context).pop();
                    },
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text("Apply"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
    );
  }

  void dbWork() async {
    Application application = Application(applicantId: widget.applicant.id!, jobId: widget.job.id!, status: "Pending");
    try{
      var x = await DatabaseUtil.instance.insertApplication(application);
      print("Application applied $x");
    } catch (e) {
      print("Application error:$e");
    }
  }
}
