import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class RegisterInstitution extends StatefulWidget {
  const RegisterInstitution({super.key});

  @override
  State<RegisterInstitution> createState() => _RegisterInstitutionState();
}

class _RegisterInstitutionState extends State<RegisterInstitution> {
  final _formKey = GlobalKey<FormState>();
  final auth_cache = Hive.box('auth_cache');

  ApiFunctions api = ApiFunctions();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController institution_name = TextEditingController();

  bool isAvailabeGlobal = false;
  bool showPassword = false;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                if (await api.isInstitutionUsernameAvailable(value)) {
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
                suffixIcon: (isAvailabeGlobal && username.text.length >= 5) ? const Icon(Icons.check, color: Colors.green,) : const Icon(Icons.error, color: Colors.red,),
                focusColor: Colors.amber,
                hintText: "Please Enter Username",
                label: const Text("Username"),
                errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
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
                  focusColor: Colors.amber,
                  hintText: "Please Enter a Password",
                  label: const Text("Password"),
                  errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(10.0) ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.blue))
                  )
                ),
            ), 

            const SizedBox(height: 20,),
            
            /**
             * INSTITUTION NAME
             */

            FractionallySizedBox(
              widthFactor: 0.9,
              child: TextFormField(
                controller: institution_name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the Medical Institution';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  focusColor: Colors.amber,
                  hintText: "Please Enter Institution's Name",
                  label: const Text("Institution's name"),
                  errorBorder:  OutlineInputBorder(borderSide: const BorderSide(color: Color.fromARGB(255, 245, 34, 19)) ,borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.blue))
                  )
                ),
            ),

            const SizedBox(height: 20),
            (!showLoading) ? FractionallySizedBox(
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
                    showLoading = !showLoading;
                  });
            
                  final messenger = ScaffoldMessenger.of(context);
                  
                  if (await api.isInstitutionUsernameAvailable(username.text) == false) {
                    messenger.showSnackBar(const SnackBar(content: Text("Username Already Taken")));
                    setState(() {
                      showLoading = !showLoading;
                    });
                    return;
                  }
            
                  if (_formKey.currentState!.validate()) {

                    Map<String,String> details = {
                      "username": username.text,
                      "password": password.text,
                      "name_of_institution": institution_name.text
                    };
            
                    Map<String, dynamic> result = await api.registerInstitution(details);
            
                    if (result['message'] == null) {
                      username.text = '';
                      password.text = '';
                      await auth_cache.clear();
                      await auth_cache.add(result);
                      messenger.showSnackBar(const SnackBar(content: Text("You are Registered")));
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    } else {
                      messenger.showSnackBar(const SnackBar(content: Text("You are Not Registered")));
                    }
                    setState(() {
                      showLoading = !showLoading;
                    });
            
                  } else {
                    setState(() {
                      showLoading = !showLoading;
                    });
                  }
                }, 
              
                child: const Text("Register Institution", style: TextStyle(fontSize: 16),)
              ),
            ) : const CircularProgressIndicator() 
        ],
      )
    );
  }
}