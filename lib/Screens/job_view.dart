import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Model/application_model.dart';
import '../Model/job_model.dart';

class JobView extends StatefulWidget {
  final Job job;
  const JobView({required this.job, super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  Application application;
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
        body: Container(
          child: Column(
            children: [
              Text(job.title),
              Text(job.description),
              Text(job.location),
              Text(job.requirements),
              Text(job.type),
              Text(DateFormat('dd MMM, yyyy').format(job.createdDate)),
              Text(DateFormat('dd MMM, yyyy').format(job.lastDate)),
            ],
          ),
        ),
    );
  }
}
