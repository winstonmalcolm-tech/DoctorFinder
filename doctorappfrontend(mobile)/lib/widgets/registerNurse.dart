import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/doctorDisplay.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisterNurse extends StatefulWidget {
  const RegisterNurse({super.key});

  @override
  State<RegisterNurse> createState() => _RegisterNurseState();
}

class _RegisterNurseState extends State<RegisterNurse> {
  final _nurseFormKey = GlobalKey<FormState>();
  var cacheData = Hive.box("auth_cache");

  String? dropDownValue;
  List<String> items = ['none'];
  bool isAvailabeGlobal = false;
  bool showPassword = false;
  bool isProcessing = false;
  ApiFunctions api = ApiFunctions();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeInstitutionList().then((value) {
      setState(() {
        items.addAll(value);
        dropDownValue = value[0];
      });
    });
    
  } 

  Future<List<String>> initializeInstitutionList() async{
    List<dynamic> results = await api.getInstitutions();
    List<String> institution = [];

    for (var result in results) {
      institution.add(result['name_of_institution']);
    }
    return institution;
  }

  Future<int> getMedId(String institution) async {
    List<dynamic> results = await api.getInstitutions();

    for (var result in results) {
      if (result.containsValue(institution)) {
        return result['med_id'];
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _nurseFormKey,
      child: Column(
        children: [
          /**
           * USERNAME
           */
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextFormField(
              controller: username,
              onChanged: (value) async {
                if (await api.isNurseUsernameAvailable(value)) {
                  setState(() {
                    isAvailabeGlobal = true;
                  });
                } else {
                  setState(() {
                    isAvailabeGlobal= false;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                } else if (value.length < 5) {
                  return "Username should not be less than 5 charaters";
                }
                return null;
              },
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                suffixIcon: (isAvailabeGlobal && username.text.length >= 5) ? const Icon(Icons.check, color: Colors.green,) : const Icon(Icons.error, color: Colors.red,),
                hintText: "Please Enter Username",
                label: const Text("Username"),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color:Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )
              ),
            ),
            if (username.text.length >= 5 && !isAvailabeGlobal) 
              const Text("Username Unavailable *", style: TextStyle(color: Colors.red, fontSize: 15),),

            const SizedBox(height: 20,),

            /**
             * PASSWORD
             */
            FractionallySizedBox(
              widthFactor: 0.9,
              child: TextFormField(
                controller: password,
                obscureText: showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },          
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {setState(() { showPassword = !showPassword;});},
                    icon: (showPassword) ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
                  ),
                  hintText: "Please Enter a Password",
                  label: const Text("Password"),
                  errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(10.0) ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.blue))
                  )
                ),
            ), 

            const SizedBox(height: 20),

            /**
             * DROPDOWN BOX
             */
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black) 
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == "None") {
                        return "Please select an institution";
                      }
                      return null;
                    },
                    
                    elevation: 0,
                    isExpanded: true,
                    value: dropDownValue,
                    items: items.map((institution) => DropdownMenuItem(value: institution, child: Text(institution))).toList(),
                    onChanged: (selectedValue) {
                      setState(() {
                        dropDownValue = selectedValue;
                      });
                    }),
                ),
              ),
            ),
            
            const SizedBox(height: 20,),
            (!isProcessing) ? FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(0, 40),
                ),
                onPressed: () async {
                  setState(() {
                   isProcessing = !isProcessing; 
                  });

                  final messenger = ScaffoldMessenger.of(context);
                  
                  if (await api.isNurseUsernameAvailable(username.text) == false) {
                    messenger.showSnackBar(const SnackBar(content: Text("Username Already Taken")));
                    setState(() {
                      isProcessing = !isProcessing; 
                    });
                    return;
                  }

                  if (_nurseFormKey.currentState!.validate()) {
                    int institutionId = await getMedId(dropDownValue!);

                    Map<String,dynamic> registrationDetails = {
                      "username": username.text,
                      "password": password.text,
                      "institution": dropDownValue,
                      "institution_id": institutionId 
                    };

                    Map<String, dynamic> result = await api.RegisterNurse(registrationDetails);

                    if (result['message'] == null) {
                      username.text = '';
                      password.text = '';
                      await cacheData.clear();
                      await cacheData.add(result);
                      messenger.showSnackBar(const SnackBar(content: Text("You are registered")));
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DoctorDisplay()));
                    } else {
                      messenger.showSnackBar(const SnackBar(content: Text("You are not registered")));
                    }

                    setState(() {
                      isProcessing = !isProcessing;
                    });
                  } else {
                    setState(() {
                      isProcessing = !isProcessing;
                    });
                  }
                  
                }, 
              
                child: const Text("Register Nurse", style: TextStyle(fontSize: 16),)
              ),
            ) : const CircularProgressIndicator(),
        ]
      ),
    );
  }
}