import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Model/applicant_model.dart';
import 'package:resumate/Model/application_model.dart';
import 'package:resumate/Model/company_model.dart';
import 'package:resumate/Model/job_model.dart';
import 'package:resumate/Screens/drawer.dart';
import 'package:resumate/Screens/posted_jobs.dart';
import 'package:resumate/Screens/show_applicants.dart';
import '../Database/sqflite_database.dart';
import '../Model/user_model.dart';

class CompanyDashboard extends StatefulWidget {
  final User user;
  const CompanyDashboard({required this.user, super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  // late Map<Job, List<Application>> jobWithApplicants = {};
  late List<Application> applicationList = List.empty();
  late List<Applicant> applicantList = List.empty();
  late List<Job> jobList = List.empty();
  late Company currentCompany;
  bool isLoading = false;


  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchApplicants().then((_) {
      fetchJobs().then((_) {
        fetchCompany().then((_){
          fetchApplications().then((_){
            setState(() {
              isLoading = false;
            });
          });
        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    if(isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: Text(
              "Dashboard",
              style: GoogleFonts.poppins(fontSize: width * 0.05, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            elevation: 0,
            bottom: const TabBar(
              labelColor: Colors.blueGrey,
              tabs: [
                Tab(text: 'All Applicant', icon: Icon(Icons.list, color: Colors.blueGrey,)),
                Tab(text: 'Posted Jobs', icon: Icon(Icons.assignment, color: Colors.blueGrey,),)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ShowApplicants(allApplicants: applicantList,currentCompany: currentCompany,),
              PostedJobs(allJobs: jobList, currentCompany: currentCompany,),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                SideDrawerHeader(name: widget.user.name),
                const SideDrawerList(),
              ],
            ),
          ),
        ),
      );
    }

  }

  Future<List<Application>> fetchApplications() async {
    applicationList = await DatabaseUtil.instance.getAllApplications();
    return applicationList;
  }

  Future<List<Job>> fetchJobs() async {
    jobList = await DatabaseUtil.instance.getAllJobs();
    return jobList;
  }

  Future<List<Applicant>> fetchApplicants() async {
    applicantList = await DatabaseUtil.instance.getAllApplicants();
    return applicantList;
  }

  Future<Company> fetchCompany() async {
    currentCompany = (await DatabaseUtil.instance.getCompany(widget.user.email))!;
    return currentCompany;
  }

}
