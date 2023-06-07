import 'package:doctorapp/model/apiModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddWard extends StatefulWidget {
  const AddWard({super.key});

  @override
  State<AddWard> createState() => _AddWardState();
}

class _AddWardState extends State<AddWard> {
  final _addWardFormKey = GlobalKey<FormState>();
  TextEditingController wardName = TextEditingController();
  bool showLoading = false;
  final authCache = Hive.box('auth_cache');
  ApiFunctions api = ApiFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add ward"),
      ),
      body: Form(
        key: _addWardFormKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
             FractionallySizedBox(
                  widthFactor: 0.9,
                  child: TextFormField(
                    controller: wardName,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Please enter a ward name";
                      }
        
                      return null;
                    },
                    decoration: InputDecoration(
                      focusColor: Colors.amber,
                      hintText: "Please Enter Ward Name",
                      label: const Text("Ward Name"),
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

                    if (_addWardFormKey.currentState!.validate()) {
                      Map<String,dynamic> details = {
                        "ward_name": wardName.text,
                        "institution_id": authCache.get(0)['med_id'],
                      };
                      bool isSaved = await api.saveWard(details);
                    
                      if (isSaved) {
                        wardName.text = '';
                        messenger.showSnackBar(const SnackBar(content: Text("Saved Successfully")));
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