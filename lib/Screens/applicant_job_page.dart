import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/applicant_model.dart';
import '../Model/company_model.dart';
import '../Model/job_model.dart';
import 'job_view.dart';

class JobsPage extends StatefulWidget {
  final List<Company> companyList;
  final List<Job> jobList;
  final Applicant currentApplicant;
  const JobsPage({
    required this.companyList,
    required this.jobList,
    required this.currentApplicant,
    super.key
  });

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  bool showSoftSkills = false;
  bool showTechSkills = false;
  final Map<Company, List<Job>> companiesWithJobs = {};
  late Map<Company, List<Job>> companiesMatchSoftSkills = {};
  late Map<Company, List<Job>> companiesWithTechSkills = {};
  late Map<Company, List<Job>> companiesMatch = {};

  @override
  void initState() {
    makeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: companiesWithJobs.isEmpty
              ? Text('No Company registered', style: GoogleFonts.poppins())
              : buildJobsList(),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: companiesWithJobs.isEmpty
                ? null // Disable the button when companiesWithJobs is empty
                : () {
              onFilterButtonPressed(context);
            },
          ),
        ),
      ],
    );
  }

  Widget buildJobsList() {
    Map<Company, List<Job>> filteredCompaniesWithJobs = {};

    if (showSoftSkills && showTechSkills) {
      filteredCompaniesWithJobs = companiesMatch;
    } else if (showSoftSkills) {
      filteredCompaniesWithJobs = companiesMatchSoftSkills;
    } else if (showTechSkills) {
      filteredCompaniesWithJobs = companiesWithTechSkills;
    } else {
      filteredCompaniesWithJobs = companiesWithJobs;
    }

    return ListView.builder(
      itemCount: filteredCompaniesWithJobs.length,
      itemBuilder: (BuildContext context, int index) {
        Company company = filteredCompaniesWithJobs.keys.elementAt(index);
        var jobs = filteredCompaniesWithJobs[company]!;

        return Card(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  company.name,
                  style: GoogleFonts.poppins(),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int jobIndex) {
                  Job job = jobs[jobIndex];

                  return ListTile(
                    title: Text(job.title, style: GoogleFonts.poppins()),
                    subtitle: Text(job.description, style: GoogleFonts.poppins()),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                JobView(job: job)
                        ),
                      );
                    },
                  );
                },
              ),
            ],
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
          title: const Text('Filter by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Soft Skills'),
                value: showSoftSkills,
                onChanged: (value) {
                  setState(() {
                    showSoftSkills = value!;
                    Navigator.of(context).pop();
                    _showFilterDialog(context);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Technical Skills'),
                value: showTechSkills,
                onChanged: (value) {
                  setState(() {
                    showTechSkills = value!;
                    Navigator.of(context).pop();
                    _showFilterDialog(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onFilterButtonPressed(BuildContext context) {
    _showFilterDialog(context);
  }

  void makeList() {
    for(Company company in widget.companyList){
      List<Job> jobs = List.empty();
      for(Job job in widget.jobList){
        if(job.companyId == company.id){
          jobs.add(job);
        }
      }
      companiesWithJobs[company] = jobs;
    }


    companiesMatchSoftSkills = Map.fromEntries(companiesWithJobs.entries
        .where((entry) => entry.key.softRating <= widget.currentApplicant.softRating));

    companiesWithTechSkills = Map.fromEntries(companiesWithJobs.entries
        .where((entry) => entry.key.techRating <= widget.currentApplicant.techRating));

    companiesMatch = Map.fromEntries(companiesWithJobs.entries
        .where((entry) =>
    entry.key.softRating <= widget.currentApplicant.softRating &&
        entry.key.techRating <= widget.currentApplicant.techRating));
  }
}
