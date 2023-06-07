import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/doctorDisplay.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginNurse extends StatefulWidget {
  const LoginNurse({super.key});

  @override
  State<LoginNurse> createState() => _LoginNurseState();
}

class _LoginNurseState extends State<LoginNurse> {
  final _loginNurseKey = GlobalKey<FormState>();

  ApiFunctions api = ApiFunctions();
  final authCache = Hive.box('auth_cache');

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool showPassword = false;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginNurseKey,
      child: Column(
        children:  [
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                /**
                 * USERNAME
                 */
                TextFormField(
                  controller: username,
                  style: const TextStyle(fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a username";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text("Username"),
                    hintText: "Please Enter username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                
                const SizedBox(height: 20),
                /**
                 * PASSWORD
                 */
                TextFormField(
                  controller: password,
                  obscureText: showPassword,
                  style: const TextStyle(fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: (showPassword) ? IconButton(onPressed: () => setState((){showPassword = !showPassword;}), icon: const Icon(Icons.visibility)) : IconButton(onPressed: () => setState(() {showPassword = !showPassword;}), icon: const Icon(Icons.visibility_off)),
                    label: const Text("Password"),
                    hintText: "Please Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),

                const SizedBox(height: 20),

                (!showLoading) ? 
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(0, 40)
                      ),
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        setState(() {
                          showLoading = !showLoading;
                        });

                        if (_loginNurseKey.currentState!.validate()) {
                          
                          Map<String, String> loginCredential = {
                            "username": username.text,
                            "password": password.text
                          };

                          Map<String, dynamic> result = await api.loginNurse(loginCredential);

                          if (result['message'] == null) {
                            username.text = '';
                            password.text = '';
                            await authCache.clear();
                            await authCache.add(result);
                            messenger.showSnackBar(const SnackBar(content: Text("You are logged in")));
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DoctorDisplay()));
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
                      child: const Text("Login Nurse", style: TextStyle(fontSize: 17),)
                    ),
                  ) : const CircularProgressIndicator(),
              ],
            ),
          )
        ]
      ),
    );
  }
}