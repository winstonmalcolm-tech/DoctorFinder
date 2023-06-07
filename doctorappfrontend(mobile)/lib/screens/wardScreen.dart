import 'package:doctorapp/model/apiModel.dart';
import 'package:doctorapp/screens/addWard.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:doctorapp/screens/AddWardDoctor.dart';

class WardScreen extends StatefulWidget {
  const WardScreen({super.key});

  @override
  State<WardScreen> createState() => _WardScreenState();
}

class _WardScreenState extends State<WardScreen> {
  Future<List<Ward>>? allwards;
  ApiFunctions api = ApiFunctions();
  final authCache = Hive.box('auth_cache');

  @override
  void initState() {
    super.initState();
    allwards = api.getWards(authCache.get(0)['med_id']);
  }

  Future<void> _refreshWard() async{
    List<Ward> tempData = await api.getWards(authCache.get(0)['med_id']);

    setState(() {
      allwards = Future.value(tempData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("All wards"),
      ),

      body: FutureBuilder<List<Ward>>(
        future: allwards,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());

          } else if (snapshot.connectionState == ConnectionState.done) {

              if (!snapshot.hasData) {
                return const Center(child: Text("There are no saved wards", style: TextStyle(fontSize: 20),));
              }
              
              List<Ward> givenWards = snapshot.data!;
              
              return RefreshIndicator(
                onRefresh: _refreshWard,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ListView.builder(
                          itemCount: givenWards.length,
                          itemBuilder: (context, index) {
                            Ward singleWard = givenWards[index];
                                    
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
                                ),
                              ),
                              onDismissed: (direction) async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  bool isDeleted = await api.deleteWard(singleWard.wardId);
                                  if (isDeleted) {
                                    messenger.showSnackBar(const SnackBar(content: Text("Delete successful")));
                                  } else {
                                    messenger.showSnackBar(const SnackBar(content: Text("Delete successful")));
                                  }
                              },
                              
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  title: Text(singleWard.wardName,style: const TextStyle(fontSize: 20),),
                                  trailing: const Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorWard(wardName: singleWard.wardName, wardId: singleWard.wardId,)));
                                  },
                                ),
                              ),
                            );
                          }
                        ),
                      ),

                      if (givenWards.isEmpty)
                        const Center(child: Text("There are no saved wards", style: TextStyle(fontSize: 20),))
                    ] 
                  ),
                ),
              );
          } 

          return const Center(child: CircularProgressIndicator());
        }
        
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddWard()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}