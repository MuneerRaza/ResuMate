import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Screens/post_job.dart';

import '../Model/company_model.dart';
import '../Model/job_model.dart';

class PostedJobs extends StatefulWidget {
  static List<Job> newJobs = [];
  final List<Job> allJobs;
  final Company currentCompany;
  const PostedJobs({required this.allJobs,
    required this.currentCompany,
    super.key});

  @override
  State<PostedJobs> createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  late List<Job> allCompanyJobs = List.empty();
  late List<Job> currentCompanyJobs = List.empty();
  bool showPrevJobs = false;

  @override
  void initState() {
    makeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Center(
          child: (showPrevJobs ? allCompanyJobs.isEmpty : currentCompanyJobs.isEmpty )
              ? Text('No Job Posted', style: GoogleFonts.poppins())
              : buildJobsList(),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Posted Jobs", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),),
                )),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: (showPrevJobs ? allCompanyJobs.isEmpty : currentCompanyJobs.isEmpty )
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
          child: FloatingActionButton(onPressed: (){
            Navigator.of(context)
                .push(_createRoute(PostAJob(company: widget.currentCompany,)));
          },
          child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget buildJobsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: ListView.builder(
            itemCount: currentCompanyJobs.length,
            itemBuilder: (BuildContext context, int index) {
              Job job = currentCompanyJobs[index];

              return SingleChildScrollView(
                child: Card(
                  child: ListTile(
                    leading: Text(job.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Job Type: ${job.type}'),
                        Text('Last Date to Apply: ${job.lastDate}'),
                      ],
                    ),
                    onTap: (){

                    },
                  ),
                ),
              );
            },
          ),
        ),
        if(showPrevJobs)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: ListView.builder(
            itemCount: allCompanyJobs.length,
            itemBuilder: (BuildContext context, int index) {
              Job job = allCompanyJobs[index];

              return SingleChildScrollView(
                child: Card(
                  child: ListTile(
                    leading: Text(job.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Job Type: ${job.type}', style: const TextStyle(color: Colors.grey),),
                        Text('Last Date to Apply: ${job.lastDate}', style: const TextStyle(color: Colors.grey),),
                      ],
                    ),
                    onTap: (){

                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

  void makeList() {
    DateTime currentDate = DateTime.now();
    for(Job job in widget.allJobs){
      if(widget.currentCompany.id == job.companyId){
        allCompanyJobs.add(job);
        if(job.lastDate.isAfter(currentDate) || job.lastDate.isAtSameMomentAs(currentDate)){
          currentCompanyJobs.add(job);
        }
      }
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
