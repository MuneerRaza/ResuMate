import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resumate/Model/job_model.dart';

import '../Database/sqflite_database.dart';
import '../Model/applicant_model.dart';
import '../Model/application_model.dart';

class AppliedJobs extends StatefulWidget {
  final Applicant applicant;
  const AppliedJobs({super.key, required this.applicant});

  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  late List<Application> applicationList = [];

  late List<Job> allJobs;

  @override
  void initState() {
    print("init");
    _fetchApplication();
    _getJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(applicationList);
      return Stack(
        children: [
          Center(
            child: applicationList.isEmpty
                ? Text('No Applications Yet', style: GoogleFonts.poppins())
                : Padding(
              padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
              child: buildJobsList(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Applied Jobs", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      );
  }


  Widget buildJobsList() {

    return ListView.builder(
      itemCount: applicationList.length,
      itemBuilder: (BuildContext context, int index) {
        Application application = applicationList[index];

        return SingleChildScrollView(
          child: Card(
            child: ListTile(
              leading: Text('For $getJobName', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Status: ${application.status}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _fetchApplication() async {
    applicationList = await DatabaseUtil.instance.getAllApplications();
  }
  
  _getJobs() async {
    allJobs = await DatabaseUtil.instance.getAllJobs();
  }

  String getJobName(Application application){
    Job matchingJob = allJobs.firstWhere((job) => job.id == application.jobId);
      return matchingJob.title;
  }
}


