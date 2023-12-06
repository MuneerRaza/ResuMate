import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumate/Model/applicant_model.dart';

class ApplicantDetailsView extends StatefulWidget {
  final Applicant applicant;
  const ApplicantDetailsView({required this.applicant, super.key});

  @override
  State<ApplicantDetailsView> createState() => _ApplicantDetailsViewState();
}

class _ApplicantDetailsViewState extends State<ApplicantDetailsView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    var applicant = widget.applicant;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Applicant Details",
          style: GoogleFonts.poppins(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Set text color
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Set icon color
      ),
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
                  "Name:",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.name,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Email:",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.email,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Address:",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.address,
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Soft Rating:",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.softRating.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tech Rating:",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.techRating.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
