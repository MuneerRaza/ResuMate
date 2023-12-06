import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resumate/Screens/post_job.dart';

import '../Database/sqflite_database.dart';
import '../Model/company_model.dart';
import '../Model/job_model.dart';
import 'job_details.dart';

class PostedJobs extends StatefulWidget {
  static List<Job> newJobs = [];
  final Company currentCompany;
  const PostedJobs({
    required this.currentCompany,
    super.key});

  @override
  State<PostedJobs> createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  late List<Job> allJobs = [];
  late List<Job> allCompanyJobs = [];
  late List<Job> currentCompanyJobs = [];
  bool showPrevJobs = true;
  bool isLoading = true;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState() {

    _fetchJobs().then((_) {makeList();
    setState(() {
      isLoading = false;
    });
    } );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if loading
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blueGrey,),
        ),
      );
    } else {
      return Stack(
        children: [
          Center(
            child: (showPrevJobs ? allCompanyJobs.isEmpty : currentCompanyJobs.isEmpty)
                ? Text('No Job Posted', style: GoogleFonts.poppins())
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
                  child: Text("Posted Jobs", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: (showPrevJobs ? allCompanyJobs.isEmpty : currentCompanyJobs.isEmpty)
                      ? null
                      : () {
                    _showFilterDialog(context);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute(PostAJob(company: widget.currentCompany)));
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      );
    }
  }


  Widget buildJobsList() {
    var thisList = showPrevJobs ? allCompanyJobs : currentCompanyJobs;

    return ListView.builder(
      itemCount: thisList.length,
      itemBuilder: (BuildContext context, int index) {
        Job job = thisList[index];

        return SingleChildScrollView(
          child: Card(
            child: ListTile(
              leading: Text(job.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Job Type: ${job.type}'),
                  const SizedBox(height: 10,),
                  Text('Last Date: ${DateFormat('dd MMM, yyyy').format(job.lastDate)}'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          JobDetails(job: job)
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: ListTile(
            title: const Text('Show Previous Jobs'),
            trailing: Checkbox(
              value: showPrevJobs,
              onChanged: (value) {
                setState(() {
                  showPrevJobs = value ?? false;
                  Navigator.pop(context);
                  _showFilterDialog(context);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchJobs() async {
    allJobs = await DatabaseUtil.instance.getAllJobs();
  }

  void makeList() {
    DateTime currentDate = DateTime.now();
    allCompanyJobs = List.from(allJobs.where((job) => widget.currentCompany.id == job.companyId));

    currentCompanyJobs = List.from(allCompanyJobs.where((job) =>
    job.lastDate.isAfter(currentDate) || job.lastDate.isAtSameMomentAs(currentDate)
    ));

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
