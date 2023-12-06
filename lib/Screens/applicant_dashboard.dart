import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Model/application_model.dart';
import 'package:resumate/Model/company_model.dart';
import 'package:resumate/Model/job_model.dart';
import 'package:resumate/Screens/drawer.dart';
import 'package:resumate/Database/sqflite_database.dart';
import '../Model/applicant_model.dart';
import '../Model/user_model.dart';
import 'applicant_job_page.dart';

class ApplicantDashboard extends StatefulWidget {
  final User user;
  const ApplicantDashboard({required this.user, super.key});

  @override
  State<ApplicantDashboard> createState() => _ApplicantDashboardState();
}

class _ApplicantDashboardState extends State<ApplicantDashboard> {
  late List<Company> companyList = List.empty();
  late List<Job> jobList = List.empty();
  late Applicant currentApplicant;
  late List<Application> applicationList = List.empty();
  bool isLoading = false;


  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchCompanies().then((_) {
      fetchJobs().then((_) {
        fetchApplicant().then((_){
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
              Tab(text: 'Jobs', icon: Icon(Icons.list, color: Colors.blueGrey,)),
              Tab(text: 'Applied Jobs', icon: Icon(Icons.assignment, color: Colors.blueGrey,),)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            JobsPage(companyList: companyList, jobList: jobList, currentApplicant: currentApplicant),
            // PreviousJobPage()
            Text("tab2")
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              SideDrawerHeader(name: widget.user.name,),
              const SideDrawerList(),
            ],
          ),
        ),
      ),
    );
    }

  }

  Future<List<Company>> fetchCompanies() async {
    companyList = await DatabaseUtil.instance.getAllCompanies();
    return companyList;
  }

  Future<List<Job>> fetchJobs() async {
    jobList = await DatabaseUtil.instance.getAllJobs();
    return jobList;
  }

  Future<Applicant> fetchApplicant() async{
    currentApplicant = (await DatabaseUtil.instance.getApplicant(widget.user.email))!;
    return currentApplicant;
  }

  Future<List<Application>> fetchApplications() async {
    final db = await DatabaseUtil.instance.database;
    const orderBy = '${ApplicationFields.applicantId} ASC';

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM $applicationTable
    WHERE ${ApplicationFields.applicantId} = ${currentApplicant.id}
    ORDER BY $orderBy
    ''');

    return result.map((json) => Application.fromJson(json)).toList();
  }


}
