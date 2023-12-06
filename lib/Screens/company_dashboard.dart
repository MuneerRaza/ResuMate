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
  late List<Application> applicationList = [];
  late List<Applicant> applicantList = [];
  late Company currentCompany;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchApplicants();
    await _fetchCompany();
    await _fetchApplications();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    if (isLoading) {
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
              ShowApplicants(allApplicants: applicantList, currentCompany: currentCompany,),
              PostedJobs(currentCompany: currentCompany,),
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

  Future<void> _fetchApplications() async {
    applicationList = await DatabaseUtil.instance.getAllApplications();
  }


  Future<void> _fetchApplicants() async {
    applicantList = await DatabaseUtil.instance.getAllApplicants();
  }

  Future<void> _fetchCompany() async {
    var x = await DatabaseUtil.instance.getCompany(widget.user.email);

    if(x!=null){
      currentCompany = x;
    }
    else{
      print("Company dashboard currentCompany get error");
    }
  }
}
