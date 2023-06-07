import 'package:doctorapp/screens/addDoctor.dart';
import 'package:doctorapp/screens/updateDoctor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/apiModel.dart';

class DoctorScreenBottomNav extends StatefulWidget {
  const DoctorScreenBottomNav({super.key});

  @override
  State<DoctorScreenBottomNav> createState() => _DoctorScreenBottomNavState();
}

class _DoctorScreenBottomNavState extends State<DoctorScreenBottomNav> {
  Future<List<Doctor>>? _futureDoctors;
  ApiFunctions api = ApiFunctions();
  final authCache = Hive.box('auth_cache');

  @override
  void initState() {
    super.initState();
    _futureDoctors = api.employedDoctors(authCache.get(0)['med_id']);
  }

  Future<void> refreshScreen() async{
    List<Doctor> freshDoctors = await api.employedDoctors(authCache.get(0)['med_id']);
    
    setState(() {
      _futureDoctors = Future.value(freshDoctors);
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber
    );

    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("All Doctors"),
      ),

      body: FutureBuilder<List<Doctor>>(
        future: _futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {

            if (!snapshot.hasData) {
              return const Center(child: Text("Not doctors Saved"));
            }
            List<Doctor> doctors = snapshot.data!;

            return RefreshIndicator(
              onRefresh: refreshScreen,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          Doctor doctor = doctors[index];
                      
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10,),
                                  Icon(Icons.cancel, color: Colors.white70,),
                                ],
                              )
                            ),
                            onDismissed: (direction) async {
                              final messenger = ScaffoldMessenger.of(context);
                              bool isDeleted = await api.deleteDoctor(doctor.doctorId);
                    
                              if (isDeleted == true) {
                                messenger.showSnackBar(const SnackBar(content: Text("Delete successful")));
                              } else {
                                messenger.showSnackBar(const SnackBar(content: Text("Delete unsuccessful")));
                              }
                            },
                            child: ListTile(
                              leading: letterIcon(doctor.firstName[0]),
                              title: Text("${doctor.firstName} ${doctor.lastName}", style: const TextStyle(fontSize: 18),),
                              trailing: IconButton(onPressed: () => _makePhoneCall(doctor.telephone), icon: const Icon(Icons.call, color: Colors.green,)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDoctor(doctorId: doctor.doctorId, firstName: doctor.firstName, lastName: doctor.lastName, telephone: doctor.telephone, )));
                              },
                            ),
                          );
                        }
                      ),
                  ),

                  if (doctors.isEmpty)
                    const Center(child: Text("There are no saved doctors", style: TextStyle(fontSize: 20),))
                ]
              ),
            );
          }  
            
          return const Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDoctor())),
        tooltip: "Add Doctor", 
        child: const Icon(Icons.add),
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