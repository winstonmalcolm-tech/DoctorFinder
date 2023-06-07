import 'package:doctorapp/model/apiModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UpdateDoctor extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String telephone;
  final int doctorId;

  const UpdateDoctor({required this.doctorId, required this.firstName, required this.lastName, required this.telephone ,super.key});

  @override
  State<UpdateDoctor> createState() => _UpdateDoctorState();
}

class _UpdateDoctorState extends State<UpdateDoctor> {
  final _updateDoctorKey = GlobalKey<FormState>();
  final authCache = Hive.box('auth_cache');
  bool showLoading = false;
  ApiFunctions api = ApiFunctions();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telephone = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName.text = widget.firstName;
    lastName.text = widget.lastName;
    telephone.text = widget.telephone;

  }

  @override
  Widget build(BuildContext context) {
    //var args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr ${widget.lastName}"),
        elevation: 0,
      ),

      body: Form(
        key: _updateDoctorKey,
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

                    if (_updateDoctorKey.currentState!.validate()) {
                      Map<String,dynamic> details = {
                        "firstName": firstName.text,
                        "lastName": lastName.text,
                        "telephone": telephone.text,
                        "doctorId": widget.doctorId
                      };
                      bool isUpdated = await api.updateDoctor(details);

                      if (isUpdated) {
                        messenger.showSnackBar(const SnackBar(content: Text("Updated Successfully")));
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
                  child: const Text("Update"),
                ),
              ) : const CircularProgressIndicator(),

            ],
          ),
        ),

      ),
    );
  }
}