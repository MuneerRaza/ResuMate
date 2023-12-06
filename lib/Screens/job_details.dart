import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Database/sqflite_database.dart';
import '../Model/job_model.dart';

class JobDetails extends StatefulWidget {
  final Job job;
  const JobDetails({super.key, required this.job});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  late TextEditingController lastDateController = TextEditingController();
  String titleController = '';
  String descriptionController = '';
  String requirementsController = '';
  String payController = '';
  String locationController = '';
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();

  DateTime? selectedCreatedDate;
  DateTime? selectedLastDate;

  String? jobType;

  bool isLoading = true;


  @override
  void initState() {
    _initData();
    setState(() {
      isLoading = false;
    });
    print("init");
    super.initState();
  }

  _initData() async {
    lastDateController = TextEditingController(
      text: DateFormat('MMM d, yyyy').format(widget.job.lastDate),
    );
    titleController = widget.job.title;
    descriptionController = widget.job.description;
    requirementsController = widget.job.requirements;
    payController = widget.job.pay.toString().split('.').first;
    locationController = widget.job.location;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    jobType = widget.job.type;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Job Details",
          style: GoogleFonts.poppins(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formfield,
          child: Column(
            children: [
              TextFormField(
                initialValue: titleController,
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
                onChanged: (text){
                  titleController = text;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: descriptionController,
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
                onChanged: (text){
                  descriptionController = text;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: requirementsController,
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
                onChanged: (text){
                  requirementsController = text;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: payController,
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
                onChanged: (text){
                  payController = text;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: locationController,
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
                onChanged: (text){
                  locationController = text;
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
                  else if (_formfield.currentState!.validate()) {
                    Job newJob = Job(title: titleController.trim(),
                        companyId: widget.job.companyId,
                        description: descriptionController.trim(),
                        requirements: requirementsController.trim(),
                        pay: double.parse(payController),
                        type: jobType!,
                        location: locationController.trim(),
                        createdDate: widget.job.createdDate,
                        lastDate: DateFormat('MMM d, yyyy').parse(lastDateController.text.trim()));
                    setState(() {
                      isLoading = true;
                    });
                    dbWork(newJob).then((_){
                      SnackBar(
                        content: Text(
                          'Job Updated',
                          style: GoogleFonts.poppins(),
                        ),
                        duration: const Duration(seconds: 1),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
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
                  "Update",
                  style: GoogleFonts.poppins(fontSize: width * 0.04),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  dbDelete();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.only(
                      left: width * 0.38,
                      right: width * 0.38,
                      top: 10,
                      bottom: 10),
                ),
                child: isLoading ? const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ): Text(
                  "Delete",
                  style: GoogleFonts.poppins(fontSize: width * 0.04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> dbWork(Job job) async {
    try {
      await DatabaseUtil.instance.updateJob(widget.job.id!, job);
    } catch (e) {
      print("Error updating job: $e");
    }
  }

  Future<void> dbDelete() async {
    try{
      await DatabaseUtil.instance.deleteJob(widget.job.id!);
    } catch (e) {
      print("Error deleting job: $e");
    }
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
