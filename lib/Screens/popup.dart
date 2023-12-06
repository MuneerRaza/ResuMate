import 'package:flutter/material.dart';
import 'package:resumate/Model/applicant_model.dart';
import 'package:resumate/Model/company_model.dart';
import 'package:resumate/Screens/applicant_dashboard.dart';
import 'package:resumate/Screens/company_dashboard.dart';

import '../Database/sqflite_database.dart';
import '../Model/user_model.dart';
import '../global_identifier.dart';

class CategorySelectionPopup extends StatefulWidget {
  final BuildContext signUpContext;
  final User user;
  const CategorySelectionPopup({required this.user, required this.signUpContext, super.key});

  @override
  State<CategorySelectionPopup> createState() => _CategorySelectionPopupState();
}

class _CategorySelectionPopupState extends State<CategorySelectionPopup> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  String? selectedCategory;
  bool showSliders = false;
  double technicalScore = 0;
  double softSkillScore = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text('Signup as'),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0), // Add padding from the bottom
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Applicant'),
                  value: 'Applicant',
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Company'),
                  value: 'Company',
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                if (selectedCategory != null)
                const SizedBox(height: 30,),
                if (selectedCategory != null)
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Address!";
                    }
                  },
                ),
                if (selectedCategory != null)
                const SizedBox(height: 20,),
                if (selectedCategory != null)
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneNoController,
                  decoration: const InputDecoration(
                    labelText: "Phone No",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Phone No!";
                    }
                  },
                ),
                const SizedBox(height: 30,),
                if (selectedCategory == 'Company' || selectedCategory == 'Applicant')
                  Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text('${selectedCategory == 'Company' ? 'Required' : 'Rate your'} Technical Score: ${technicalScore.toInt()}'),
                      Slider(
                        value: technicalScore,
                        onChanged: (value) {
                          setState(() {
                            technicalScore = value;
                          });
                        },
                        min: 0,
                        max: 10,
                      ),
                      const SizedBox(height: 20,),
                      Text('${selectedCategory == 'Company' ? 'Required' : 'Rate your'} Soft Skill Score: ${softSkillScore.toInt()}'),
                      Slider(
                        value: softSkillScore,
                        onChanged: (value) {
                          setState(() {
                            softSkillScore = value;
                          });
                        },
                        min: 0,
                        max: 10,
                      ),
                    ],
                  ),
                Align(
                  alignment: Alignment.center, // Center the "Next" button
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedCategory != null &&
                          addressController.text.isNotEmpty &&
                          phoneNoController.text.isNotEmpty) {

                          var email = GlobalEmailKey.email;
                          final user = User(
                            email: widget.user.email,
                            name: widget.user.name,
                            password: widget.user.password,
                            role: selectedCategory,
                          );

                            dbWork(user, selectedCategory!, context,
                                addressController.text.trim(),
                                phoneNoController.text.trim(),
                            technicalScore.toInt(), softSkillScore.toInt());
                            Navigator.of(context).pop();
                            if (selectedCategory == 'Applicant') {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ApplicantDashboard(user: user)
                                ),
                              );
                            } else if(selectedCategory == 'Company'){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyDashboard(user: user)
                                ),
                              );
                            }

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All fields are required'),
                          ),
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }


  void dbWork(User user, String selectedCategory, context, String address, String phoneNo, int tech, int soft) async {
    await DatabaseUtil.instance.insertUser(user);

      if(selectedCategory == 'Applicant'){
        Applicant applicant = Applicant(name: user.name, email: user.email, address: address, phoneNo: phoneNo, techRating: tech, softRating: soft);
        await DatabaseUtil.instance.insertApplicant(applicant);
      } else if (selectedCategory == 'Company') {
        Company company = Company(name: user.name, email: user.email, location: address, phoneNo: phoneNo, techRating: tech, softRating: soft);
        try{
        await DatabaseUtil.instance.insertCompany(company);
      }catch(e){
          print("comapny insert error $e");
        }
    }

  }
}
