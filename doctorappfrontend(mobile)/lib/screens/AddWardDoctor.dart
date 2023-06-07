import 'package:doctorapp/model/apiModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DoctorWard extends StatefulWidget {
  final String wardName;
  final int wardId;
  const DoctorWard({required this.wardName, required this.wardId, super.key});

  @override
  State<DoctorWard> createState() => _DoctorWard();
}

class _DoctorWard extends State<DoctorWard> {
  Future<List<List>>? _employedDoctors;

  ApiFunctions api = ApiFunctions();
  final authCache = Hive.box('auth_cache');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _employedDoctors = api.employedDoctorsWard(authCache.get(0)['med_id'], widget.wardId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.wardName),
      ),
      body: FutureBuilder<List<List>>(
        future: _employedDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());

          } else if (snapshot.connectionState == ConnectionState.done) {
            
            if (!snapshot.hasData) {
              return const Center(child: Text("Not doctors Saved"));
            }

            List<List> doctors = snapshot.data!;

            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = doctors[index][0];
                

                return ListTile(
                  leading: letterIcon(doctor.firstName[0]),
                  title: Text("${doctor.firstName} ${doctor.lastName}", style: const TextStyle(fontSize: 18),),
                  trailing: (!isLoading) ? Checkbox(
                    value: doctors[index][1], 
                    onChanged: (bool? value) async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() {
                        isLoading = true;
                      });
                      Map<String,int> details = {
                        "ward_id": widget.wardId,
                        "doctor_id": doctor.doctorId,
                        "institution_id": authCache.get(0)['med_id'],
                      };

                      bool isSuccess = false;

                      if (doctors[index][1] == true) {
                        isSuccess = await api.removeAssignee(details);
                      } else if (doctors[index][1] == false) {
                        isSuccess = await api.assignToWard(details);
                      }
                      

                      if(isSuccess) {
                        setState(() {
                          isLoading = false;
                          doctors[index][1] = !doctors[index][1];
                        });
                        messenger.showSnackBar(const SnackBar(content: Text("Success")));
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        messenger.showSnackBar(const SnackBar(content: Text("Error")));
                      }
                    } 
                  ) : const CircularProgressIndicator(),
                );
              }
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Widget letterIcon(String letter) {
    return CircleAvatar(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient:  LinearGradient(
            colors: [
              Color(0xff9DCEFF),
              Color(0xff92A3FD)
            ] 
          ),
        ),
        child: Center(
          child: Text(letter, style: const TextStyle(color: Colors.white),),
        ),
      )
    );
  }
}