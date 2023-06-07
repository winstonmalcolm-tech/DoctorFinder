import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginInstitution extends StatefulWidget {
  const LoginInstitution({super.key});

  @override
  State<LoginInstitution> createState() => _LoginInstitutionState();
}

class _LoginInstitutionState extends State<LoginInstitution> {

  final _loginFormKey = GlobalKey<FormState>();
  final authCache = Hive.box('auth_cache');

  ApiFunctions api = ApiFunctions();

  bool showPassword = false;
  bool showLoading = false;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
           /**
           * USERNAME
           */
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextFormField(
              controller: username,
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
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0) ),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.blue))
                  )
                ),
            ), 

            const SizedBox(height: 20,),

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

                  if (_loginFormKey.currentState!.validate()) {
                    Map<String,String> details = {
                      "username": username.text,
                      "password": password.text,
                    };
            
                    Map<String, dynamic> result = await api.loginInstitution(details);
            
                    if (result['message'] == null) {
                      username.text = '';
                      password.text = '';
                      await authCache.clear();
                      await authCache.add(result);
                      messenger.showSnackBar(const SnackBar(content: Text("You are Logged In")));
                      setState(() {
                        showLoading = !showLoading;
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                      
                    } else {
                      messenger.showSnackBar(const SnackBar(content: Text("Incorrect credentials")));
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
              
                child: const Text("Login Institution", style: TextStyle(fontSize: 16),)
              ),
            ) : const CircularProgressIndicator()

            
        ],
      )
      
    );
  }
}