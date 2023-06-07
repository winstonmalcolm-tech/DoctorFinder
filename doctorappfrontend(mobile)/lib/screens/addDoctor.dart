import 'package:doctorapp/model/apiModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final _newDoctorFormKey = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telephone = TextEditingController();
  ApiFunctions api = ApiFunctions();
  var authCache = Hive.box('auth_cache');

  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add doctor"),
        elevation: 0,
      ),

      body: Form(
        key: _newDoctorFormKey,
        child: Center(
          child: Column(
            children: [

              /**
               * FIRST NAME FIELD
               */
              const SizedBox(height: 20,),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: TextFormField(
                  controller: firstName,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a first name";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    focusColor: Colors.amber,
                    hintText: "Please Enter First Name",
                    label: const Text("First Name"),
                    errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color:Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
              ),

              /**
               * LAST NAME
               */
              const SizedBox(height: 20,),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: TextFormField(
                  controller: lastName,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a last name";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    focusColor: Colors.amber,
                    hintText: "Please Enter Last Name",
                    label: const Text("Last Name"),
                    errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color:Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
              ),

              /**
               * TELEPHONE FIELD
               */
              const SizedBox(height: 20,),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: TextFormField(
                  controller: telephone,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a telephone number";
                    }

                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusColor: Colors.amber,
                    hintText: "Please Enter Telephone Number",
                    label: const Text("Telephone"),
                    errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color:Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
              ),
              
              const SizedBox(height: 20,),
              (!showLoading) ? FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);

                    setState(() {
                      showLoading = !showLoading;
                    });

                    if (_newDoctorFormKey.currentState!.validate()) {
                      Map<String,dynamic> details = {
                        "firstName": firstName.text,
                        "lastName": lastName.text,
                        "telephone": telephone.text,
                        "institution_id": authCache.get(0)['med_id']
                      };
                      bool isSaved = await api.saveDoctor(details);

                      if (isSaved) {
                        messenger.showSnackBar(const SnackBar(content: Text("Doctor Saved Successfully")));
                        firstName.text = '';
                        lastName.text = '';
                        telephone.text = '';
                      } else {
                        messenger.showSnackBar(const SnackBar(content: Text("Server error")));
                      }

                      setState(() {
                        showLoading = !showLoading;
                      });
                      return;
                    }

                    setState(() {
                      showLoading = !showLoading;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                          minimumSize: const Size(0, 40),
                        ),
                  child: const Text("Save"),
                ),
              ) : const CircularProgressIndicator(),

            ],
          ),
        ),

      ),
    );
  }
}