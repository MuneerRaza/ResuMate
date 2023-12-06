import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resumate/Screens/posted_jobs.dart';

import '../Database/sqflite_database.dart';
import '../Model/company_model.dart';
import '../Model/job_model.dart';

class PostAJob extends StatefulWidget {
  final Company company;
  const PostAJob({super.key, required this.company});

  @override
  State<PostAJob> createState() => _PostAJobState();
}

class _PostAJobState extends State<PostAJob> {
  final TextEditingController createdDateController = TextEditingController();
  final TextEditingController lastDateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController payController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? selectedCreatedDate;
  DateTime? selectedLastDate;

  String? jobType;

  bool isLoading = false;

  Job? job;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Post a Job",
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Title!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.text_fields)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Description!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: requirementsController,
                  decoration: const InputDecoration(
                    labelText: 'Requirements',
                    border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.text_fields)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Requirements!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: payController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pay',
                    border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Pay!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Location!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                buildDateSelector(
                  label: 'Created Date',
                  controller: createdDateController,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedCreatedDate = date;
                      createdDateController.text =
                          DateFormat.yMMMd().format(date);
                    });
                  },
                ),
                const SizedBox(height: 16),
                buildDateSelector(
                  label: 'Last Date',
                  controller: lastDateController,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedLastDate = date;
                      lastDateController.text =
                          DateFormat.yMMMd().format(date);
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Part Time'),
                        value: 'Part Time',
                        groupValue: jobType,
                        onChanged: (value) {
                          setState(() {
                            jobType = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Full Time'),
                        value: 'Full Time',
                        groupValue: jobType,
                        onChanged: (value) {
                          setState(() {
                            jobType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if(jobType == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please Select Job Type!',
                            style: GoogleFonts.poppins(),
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                    else if (_formKey.currentState!.validate()) {
                      job = Job(title: titleController.text.trim(),
                          companyId: widget.company.id!,
                          description: descriptionController.text.trim(),
                          requirements: requirementsController.text.trim(),
                          pay: double.parse(payController.text),
                          type: jobType!,
                          location: locationController.text.trim(),
                          createdDate: DateTime.parse(createdDateController.text.trim()),
                          lastDate: DateTime.parse(lastDateController.text.trim()));
                      dbWork(job!).then((_){
                        dispose();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.only(
                        left: width * 0.37,
                        right: width * 0.37,
                        top: 10,
                        bottom: 10),
                  ),
                  child: isLoading ? const CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ): Text(
                    "Post",
                    style: GoogleFonts.poppins(fontSize: width * 0.04),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    payController.dispose();
    locationController.dispose();
    PostedJobs.newJobs.add(job!);
    super.dispose();
  }

  Future<Job> dbWork(Job job) async {
    Job x = await DatabaseUtil.instance.insertJob(job);
    return x;
  }

  Widget buildDateSelector({
    required String label,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Select $label!';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
        ),
      ],
    );
  }
}
