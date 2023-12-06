import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Model/company_model.dart';

import '../Model/applicant_model.dart';
import 'applicant_details_view.dart';

class ShowApplicants extends StatefulWidget {
  final List<Applicant> allApplicants;
  final Company currentCompany;
  const ShowApplicants({
    required this.allApplicants,
    required this.currentCompany,
    super.key
  });

  @override
  State<ShowApplicants> createState() => _ShowApplicantsState();
}

class _ShowApplicantsState extends State<ShowApplicants> {
  bool showSoftSkills = true;
  bool showTechSkills = true;
  late List<Applicant> applicantMatchSoftSkills = List.empty();
  late List<Applicant>  applicantMatchTechSkills = List.empty();
  late List<Applicant>  applicantMatch = List.empty();


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
          child: widget.allApplicants.isEmpty
              ? Text('No Company registered', style: GoogleFonts.poppins())
              : buildApplicantList(),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Applicants", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),),
                )),
              Expanded(
                flex: 1,
                child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: widget.allApplicants.isEmpty
                        ? null // Disable the button when companiesWithJobs is empty
                        : () {
                      _showFilterDialog(context);
                    },
                  ),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildApplicantList() {
    List<Applicant> filteredApplicants = [];

    if (showTechSkills && showSoftSkills) {
      filteredApplicants = applicantMatch;
    } else if (showSoftSkills) {
      filteredApplicants = applicantMatchSoftSkills;
    } else if (showTechSkills) {
      filteredApplicants = applicantMatchTechSkills;
    } else {
      filteredApplicants = widget.allApplicants;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
      child: ListView.builder(
        itemCount: filteredApplicants.length,
        itemBuilder: (BuildContext context, int index) {
          Applicant applicant = filteredApplicants[index];

          return SingleChildScrollView(
            child: Card(
              child: ListTile(
                leading: Text(applicant.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey),),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Soft Skill Score: ${applicant.softRating}'),
                  Text('Technical Skill Score: ${applicant.techRating}'),
                ],
              ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            ApplicantDetailsView(applicant: applicant)
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
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
                  ListTile(
                    title: const Text('Match Soft Skills'),
                    trailing: Checkbox(
                      value: showSoftSkills,
                      onChanged: (value) {
                        setState(() {
                          showSoftSkills = value ?? false;
                          Navigator.pop(context);
                          _showFilterDialog(context);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Match Technical Skills'),
                    trailing: Checkbox(
                      value: showTechSkills,
                      onChanged: (value) {
                        setState(() {
                          showTechSkills = value ?? false;
                          Navigator.pop(context);
                          _showFilterDialog(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }

  void makeList() {
    applicantMatchSoftSkills = widget.allApplicants
        .where((applicant) => applicant.softRating >= widget.currentCompany.softRating)
        .toList();

    applicantMatchTechSkills = widget.allApplicants
        .where((applicant) => applicant.techRating >= widget.currentCompany.techRating)
        .toList();

    applicantMatch = widget.allApplicants
        .where((applicant) =>
    applicant.softRating >= widget.currentCompany.softRating &&
        applicant.techRating >= widget.currentCompany.techRating)
        .toList();
  }


}

