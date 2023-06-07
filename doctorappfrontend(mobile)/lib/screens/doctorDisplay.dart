import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/entityScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDisplay extends StatefulWidget {
  const DoctorDisplay({super.key});

  @override
  State<DoctorDisplay> createState() => _DoctorDisplayState();
}

class _DoctorDisplayState extends State<DoctorDisplay> {

  TextEditingController searchDoctor = TextEditingController();
  ApiFunctions api = ApiFunctions();
  Future<List<Doctor>>? futureDoctors;
  final authCache = Hive.box('auth_cache');

  List<Doctor> doctorsToDisplay = [];
  List<Doctor> cacheData = [];

  @override
  void initState() {
    super.initState();
    futureDoctors = api.allDoctors(authCache.get(0)['med_id'] ?? authCache.get(0)['institution_id']);
    
    futureDoctors!.then((value) {
      setState(() {
        cacheData.addAll(value);
        doctorsToDisplay.addAll(cacheData);
      });
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
        title: const Text("Available Doctors"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async{
              await authCache.clear();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Entity()));
          }, 
          icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                controller: searchDoctor,
                onChanged: (query) {
                  setState(() {
                    doctorsToDisplay = cacheData.where((doctor) {
                      var wardName = doctor.wardName!.toLowerCase();
                      return wardName.contains(query);
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  label: const Text("Search ward"),
                  hintText: "Search ward",
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.blue),borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,),
          
          Expanded(
            child: FutureBuilder<List<Doctor>>(
              future: futureDoctors,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());

                } else if (snapshot.connectionState == ConnectionState.done) {

                  if (!snapshot.hasData) {
                    return const Center(child: Text("No doctors available", style: TextStyle(fontSize: 20)),);
                  }

                  List<Doctor> doctors = snapshot.data!;
          
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ListView.builder(
                          itemCount: doctorsToDisplay.length,
                            itemBuilder: (context, index) {
                              Doctor doctor = doctorsToDisplay[index];
                      
                              return ListTile(
                                leading: letterIcon(doctor.firstName[0]),
                                title: Text("${doctor.firstName} ${doctor.lastName}", style: const TextStyle(fontSize: 18),),
                                subtitle: Text(doctor.wardName!, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),),
                                trailing: IconButton(
                                  onPressed: () {
                                    _makePhoneCall(doctor.telephone);
                                  }, 
                                  icon: const Icon(Icons.call, color: Colors.green,)
                                ),
                              );
                            }
                        ), 
                      ),

                      if (doctors.isEmpty)
                        const Center(child: Text("There are doctors available", style: TextStyle(fontSize: 20),))
                    ]
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }
            ),
          )      
        ],
      )
    );
  }
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